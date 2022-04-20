//
//  AppUtilityTests.swift
//  WorkoutAppTests
//
//  Created by Negar Haghbin on 2022-04-19.
//  Copyright © 2022 Negar. All rights reserved.
//

import XCTest
@testable import _min_Workout

class AppUtilityTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMinutesToString() throws {
        var seconds = 0
        
        XCTAssertEqual(secondsToHMString(time: seconds), "0 minutes")
        seconds = 1
        XCTAssertEqual(secondsToHMString(time: seconds), "0 minutes")
        seconds = 120
        XCTAssertEqual(secondsToHMString(time: seconds), "2 minutes")
        seconds = 121
        XCTAssertEqual(secondsToHMString(time: seconds), "2 minutes")
        seconds = 45
        XCTAssertEqual(secondsToHMString(time: seconds), "0 minutes")
        seconds = 3600
        XCTAssertEqual(secondsToHMString(time: seconds), "1 hour")
        seconds = 3660
        XCTAssertEqual(secondsToHMString(time: seconds), "1 hour and 1 minute")
        seconds = 3720
        XCTAssertEqual(secondsToHMString(time: seconds), "1 hour and 2 minutes")
        seconds = 3721
        XCTAssertEqual(secondsToHMString(time: seconds), "1 hour and 2 minutes")
    }
    
    func testSecondsToMSString() throws {
        var seconds = 0
        
        XCTAssertEqual(secondsToMSString(time: seconds), "0 seconds")
        seconds = 1
        XCTAssertEqual(secondsToMSString(time: seconds), "1 second")
        seconds = 120
        XCTAssertEqual(secondsToMSString(time: seconds), "2 minutes")
        seconds = 121
        XCTAssertEqual(secondsToMSString(time: seconds), "2 minutes and 1 second")
        seconds = 45
        XCTAssertEqual(secondsToMSString(time: seconds), "45 seconds")
        seconds = 3600
        XCTAssertEqual(secondsToMSString(time: seconds), "60 minutes")
        seconds = 3660
        XCTAssertEqual(secondsToMSString(time: seconds), "61 minutes")
        seconds = 3720
        XCTAssertEqual(secondsToMSString(time: seconds), "62 minutes")
        seconds = 3721
        XCTAssertEqual(secondsToMSString(time: seconds), "62 minutes and 1 second")
    }
    
    func testSecondsToMinutes() throws {
        var seconds = 0
        
        XCTAssertEqual(secondsToMinutes(seconds: seconds), 0.0)
        seconds = 6
        XCTAssertEqual(secondsToMinutes(seconds: seconds), 0.1)
        seconds = 60
        XCTAssertEqual(secondsToMinutes(seconds: seconds), 1.0)
        seconds = 90
        XCTAssertEqual(secondsToMinutes(seconds: seconds), 1.5)
        seconds = 120
        XCTAssertEqual(secondsToMinutes(seconds: seconds), 2.0)
    }
    
    func testThousandsToKs() throws {
        var thousands = 0
        
        XCTAssertEqual(thousandsToKs(number: thousands), 0.0)
        thousands = 10
        XCTAssertEqual(thousandsToKs(number: thousands), 0.01)
        thousands = 600
        XCTAssertEqual(thousandsToKs(number: thousands), 0.6)
        thousands = 1000
        XCTAssertEqual(thousandsToKs(number: thousands), 1.0)
        thousands = 1200
        XCTAssertEqual(thousandsToKs(number: thousands), 1.2)
    }
    
    func stringToSeconds() throws {
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
