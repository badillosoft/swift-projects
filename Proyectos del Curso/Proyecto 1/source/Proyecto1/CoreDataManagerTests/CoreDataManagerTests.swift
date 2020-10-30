//
//  CoreDataManagerTests.swift
//  CoreDataManagerTests
//
//  Created by Dragon on 30/10/20.
//  Copyright © 2020 Brandon Escalante. All rights reserved.
//

import XCTest

@testable import Proyecto1

class CoreDataManagerTests: XCTestCase {

    var manager: CoreDataManager!
    
    override func setUp() {
        self.manager = CoreDataManager()
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testUbicacionesCount() throws {
        // TODO?: agregar algunas ubicaciones manualmente
        
        let totalUbicaciones = manager.getUbicacionesCount()
        
        XCTAssertEqual(totalUbicaciones, 2)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
