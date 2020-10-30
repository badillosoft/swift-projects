//
//  TestingTests.swift
//  TestingTests
//
//  Created by Dragon on 30/10/20.
//

import XCTest

@testable import Testing

class TestingTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let avg = StatisticsService.avg(values: 1, 2, 3)
        
        XCTAssertEqual(avg, 2.1)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
