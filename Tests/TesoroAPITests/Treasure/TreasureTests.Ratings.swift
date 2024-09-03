//
//  File.swift
//  
//
//  Created by Hugh on 3/9/2024.
//

import Foundation
import TesoroAPI
import XCTest


extension TreasureTests {
    
    func testRateTreasure() async throws {
        
        let configuration = TestConfiguration()
        let session = Session.fromCommandLine()
    
        let subject = try await Treasure.create(
            configuration: configuration,
            session: session,
            message: "Test treasure for ratings",
            location: .randomForTesting()
        )
        
        guard subject.hasBeenRatedPositively(by: session) == false else {
            XCTFail(); return
        }
        
        let _ = try await Treasure.PositiveRating.create(
            configuration: configuration,
            session: session,
            treasure: subject,
            ratingAgent: session
        )
        
        let positivelyRatedSubject = try await subject.refresh(
            configuration: configuration,
            session: session
        )
        
        XCTAssert(positivelyRatedSubject.positiveRatingCount == 1)

        guard positivelyRatedSubject.hasBeenRatedPositively(
            by: session
        ) == true else { XCTFail(); return }
        
        let _ = try await Treasure.PositiveRating.delete(
            configuration: configuration,
            session: session,
            treasure: positivelyRatedSubject,
            ratingAgent: session
        )
        
        let reversedPositivelyRatedSubject = try await subject.refresh(
            configuration: configuration,
            session: session
        )

        guard reversedPositivelyRatedSubject.hasBeenRatedPositively(
            by: session
        ) == false else { XCTFail(); return }
        
        guard subject.hasBeenRatedNegatively(by: session) == false else {
            XCTFail(); return
        }
        
        let _ = try await Treasure.NegativeRating.create(
            configuration: configuration,
            session: session,
            treasure: subject,
            ratingAgent: session
        )
        
        let negativelyRatedSubject = try await subject.refresh(
            configuration: configuration,
            session: session
        )
        
        XCTAssert(negativelyRatedSubject.negativeRatingCount == 1)

        guard negativelyRatedSubject.hasBeenRatedNegatively(
            by: session
        ) == true else { XCTFail(); return }
        
        let _ = try await Treasure.NegativeRating.delete(
            configuration: configuration,
            session: session,
            treasure: negativelyRatedSubject,
            ratingAgent: session
        )
        
        let reversedNegativelyRatedSubject = try await subject.refresh(
            configuration: configuration,
            session: session
        )

        guard reversedNegativelyRatedSubject.hasBeenRatedNegatively(
            by: session
        ) == false else { XCTFail(); return }
        
        return
        
    }
    
}
