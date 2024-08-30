//
//  File.swift
//  
//
//  Created by Hugh on 28/8/2024.
//

import Foundation

#if os(Linux)
import AsyncHTTPClient
import NIOHTTP1

extension Request {
    
    static func make<C: Configuration, D: Decodable>(
        configuration: C,
        path: String,
        method: Self.Method,
        queryItems: Array<URLQueryItem> = [],
        session: Session?
    ) async throws -> D {
        
        let result: D = try await Self.make(
            configuration: configuration,
            path: path,
            method: method,
            queryItems: queryItems,
            requestBody: nil as PlaceboEncodable?,
            session: session
        )
        
        return result
        
    }
    
    static func make<C: Configuration, E: Encodable, D: Decodable>(
        configuration: C,
        path: String,
        method: Self.Method,
        queryItems: Array<URLQueryItem> = [],
        requestBody: E?,
        session: Session?
    ) async throws -> D {
        
        let httpClient = HTTPClient.shared
        
        guard var urlComponents = URLComponents(
            string: configuration.apiEndpoint
        ) else {
            throw TesoroError(clientFacingFriendlyMessage: """
The application failed to initialise components of a URL for communicating \
with the Tesoro API
""")
        }
        
        urlComponents.path += path
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            throw TesoroError(clientFacingFriendlyMessage: """
The application failed to initialise a URL for communicating with the Tesoro \
API
""")
        }
        
        var request = HTTPClientRequest(url: url.absoluteString)
        
        request.method = method.asyncHttpMethod
        request.headers.add(name: "Accept", value: "application/json")
        request.headers.add(name: "User-Agent", value: "Tesoro Swift")
        
        
        if let session = session {
            
            guard let apiKeyData = session.apiKey.data(using: .utf8) else {
                throw TesoroError.signatureFormationFailure
            }
            
            let signature = try Signature.make(
                path: path,
                apiKey: apiKeyData
            )
            
            request.headers.add(
                name: Signature.headerName,
                value: signature
            )
            
            request.headers.add(
                name: Session.headerIdName,
                value: String(session.sessionId)
            )
            
        }
        
        if let body = requestBody {
            
            let jsonData = try Self.jsonEncoder.encode(body)
            request.body = .bytes(jsonData)
            
            request.headers.add(
                name: "Content-Type",
                value: "application/json; charset=utf-8"
            )
            request.headers.add(
                name: "Content-Length",
                value: "\(jsonData.count)"
            )
            
        }
        
        let response = try await httpClient.execute(
            request,
            timeout: .seconds(10)
        )
        
        guard response.status == .ok else {
            
            throw TesoroError(clientFacingFriendlyMessage: """
The Tesoro API responded to a request with a \(response.status.code) code
""")
            
        }
        
        let body = try await response.body.collect(upTo: 1024 * 1024 * 10)
        
        guard let data = String(buffer: body).data(using: .utf8) else {
            throw TesoroError(clientFacingFriendlyMessage: """
The application was unable to read response data from the Tesoro API
""")
        }
        
        let decoded = try Self.jsonDecoder.decode(D.self, from: data)
        
        return decoded
        
    }
    
}

extension Request.Method {
    
    var asyncHttpMethod: HTTPMethod {
        switch self {
        case .GET: return .GET
        case .POST: return .POST
        }
    }
    
}
#endif
