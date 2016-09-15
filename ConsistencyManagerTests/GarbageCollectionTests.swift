//
//  GarbageCollectionTests.swift
//  ConsistencyManager
//
//  Created by Peter Livesey on 9/15/16.
//  Copyright © 2016 LinkedIn. All rights reserved.
//

import XCTest
@testable import ConsistencyManager

class GarbageCollectionTests: ConsistencyManagerTestCase {

    /**
     This is sort of a wierd test. Basically, I want a sanity check that the garbage collection interval is correct.
     The dispatch_after logic is changing and it's difficult to tell what the units are.
     So, this verifies that the garbage collection interval is in a reasonable range.
     Sadly, one downside of this test is that it takes at least one second to run, but I think it's worth the tradeoff.
     */
    func testGarbageCollectionHappensAtCorrectTime() {
        let testExpectation = expectation(description: "Wait for garbage collection")

        let consistencyManager = MockConsistencyManager()
        let now = Date()
        consistencyManager.garbageCollectionInterval = 1
        consistencyManager.expectation = testExpectation

        waitForExpectations(timeout: 5, handler: nil)

        // Ensure that this took at least half a second
        XCTAssertTrue(-now.timeIntervalSinceNow > 0.5)
    }

    class MockConsistencyManager: ConsistencyManager {

        var expectation: XCTestExpectation?

        override func cleanMemory() {
            expectation?.fulfill()
        }
    }
}
