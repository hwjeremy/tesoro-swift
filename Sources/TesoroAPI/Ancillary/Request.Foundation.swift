//
//  File.swift
//  
//
//  Created by Hugh on 28/8/2024.
//

import Foundation


#if !os(Linux)

fileprivate struct Placebo: Decodable {
    let placebo: String?
}

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
    
    static func make<C: Configuration, E: Encodable>(
        configuration: C,
        path: String,
        method: Self.Method,
        requestBody: E,
        session: Session?
    ) async throws -> Void {
     
        let _: Placebo = try await Self.make(
            configuration: configuration,
            path: path,
            method: method,
            requestBody: requestBody,
            session: session
        )
        
        return
        
    }
    
    static func make<C: Configuration>(
        configuration: C,
        path: String,
        method: Self.Method,
        queryItems: Array<URLQueryItem> = [],
        session: Session?
    ) async throws -> Void {
     
        let _: Placebo = try await Self.make(
            configuration: configuration,
            path: path,
            method: method,
            queryItems: queryItems,
            session: session
        )
        
        return
        
    }
    
    static func make<C: Configuration, E: Encodable, D: Decodable>(
        configuration: C,
        path: String,
        method: Self.Method,
        queryItems: Array<URLQueryItem> = [],
        requestBody: E?,
        session: Session?
    ) async throws -> D {
        
        guard var urlComponents = URLComponents(
            string: configuration.apiEndpoint
        ) else {
            throw TesoroError(clientFacingFriendlyMessage: """
The application failed to initialise components of a URL for communicating \
with the Tesoro API
""")
        }

        urlComponents.path += path
        if queryItems.count > 0 {
            urlComponents.queryItems = queryItems
        }
        
        guard let url = urlComponents.url else {
            throw TesoroError(clientFacingFriendlyMessage: """
The application failed to initialise a URL for communicating with the Tesoro \
API
""")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Tesoro Swift", forHTTPHeaderField: "User-Agent")
        
        if let session = session {
            
            guard let apiKeyData = session.apiKey.data(using: .utf8) else {
                throw TesoroError.signatureFormationFailure
            }
            
            let signature = try Signature.make(
                path: path,
                apiKey: apiKeyData
            )
            
            request.addValue(
                signature,
                forHTTPHeaderField: Signature.headerName
            )
            
            request.addValue(
                session.sessionId,
                forHTTPHeaderField: Session.headerIdName
            )
            
        }
        
        if let body = requestBody {
            
            let jsonData = try Self.jsonEncoder.encode(body)
            request.httpBody = jsonData
            
            request.addValue(
                "application/json; charset=utf-8",
                forHTTPHeaderField: "Content-Type"
            )
            request.addValue(
                "\(jsonData.count)",
                forHTTPHeaderField: "Content-Length"
            )
            
        }
        
        let (data, response) = try await URLSession.shared.data(
            for: request,
            delegate: nil
        )
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw TesoroError(clientFacingFriendlyMessage: """
An HTTP request response could not be cast as an `HTTPURLResponse`
""")
        }
        
        guard httpResponse.statusCode == 200 else {
            
            let code = httpResponse.statusCode
            
            #if DEBUG
            
            var bodyData: String = "<nil>"
            
            if let body = requestBody,
               let jsonData = try? JSONEncoder().encode(body),
               let stringBody = String(data: jsonData, encoding: .utf8) {

                bodyData = stringBody
                
            }

            print("A request to Tesoro API failed.")
            print("Request to: \(url.absoluteString)")
            print("Request method: \(method.rawValue)")
            print("Request headers:")
            print(request.allHTTPHeaderFields ?? "<nil>")
            print("Request body: \(bodyData)")
            print("Response code: \(code)")
            print("Response body:")
            
            if let bodyData = String(data: data, encoding: .utf8) {
                print(bodyData)
            } else {
                print("<unavailable>")
            }
    
            #endif
            
            var m: String = ""
            if let response = try? Self.jsonDecoder.decode(
                ErrorResponse.self,
                from: data
            ) {
                m = ". Message: \(response.technicalMessage)"
            }
            
            throw TesoroError(clientFacingFriendlyMessage: """
The Tesoro API responded to a request with a \(code) code\(m)
""")
        }

        let decoded = try Self.jsonDecoder.decode(D.self, from: data)

        return decoded
    
    }
    
    struct ErrorResponse: Decodable {
        let technicalMessage: String
        private enum CodingKeys: String, CodingKey {
            case technicalMessage = "technical_message"
        }
    }
    
}
#endif
