//
//  WorkoutAppTests.swift
//  WorkoutAppTests
//
//  Created by Negar Haghbin on 2022-04-19.
//  Copyright © 2022 Negar. All rights reserved.
//

import XCTest
@testable import _min_Workout

class WorkoutAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDurationInit() throws {
        let duration = Duration()
        
        XCTAssertEqual(duration.countPerSet, -1)
        XCTAssertEqual(duration.durationInSeconds, -1)
        XCTAssertEqual(duration.numberOfSets, -1)
        XCTAssertEqual(duration.streak, -1)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
