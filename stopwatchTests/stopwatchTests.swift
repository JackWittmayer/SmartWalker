//
//  stopwatchTests.swift
//  stopwatchTests
//
//  Created by Jack Wittmayer on 12/30/19.
//  Copyright © 2019 Jack Wittmayer. All rights reserved.
//

import XCTest
@testable import stopwatch

class stopwatchTests: XCTestCase {
//make sure walk initializer returns a walk object when passed valid parameters
    func testWalkInitializationSucceeds()
    {
        // zero time
        let zeroTimeWalk = Walk.init(name: "zero", photo: nil, time: 0.0)
        XCTAssertNotNil(zeroTimeWalk)
        
        //high time
        let highTimeWalk = Walk.init(name: "high", photo: nil, time: 1200.0)
        XCTAssertNotNil(highTimeWalk)
    }
    
    func testWalkInitializationFails()
    {
        //make sure walk initializer returns nil when passed a walk with negative time or empty name
        //negative rating
        let negativeTimeWalk = Walk.init(name: "negative", photo: nil, time: -1.0)
        XCTAssertNil(negativeTimeWalk)
        
        //empty string
        let emptyStringWalk = Walk.init(name: "", photo: nil, time: 0.0)
        XCTAssertNil(emptyStringWalk)
    }

}
