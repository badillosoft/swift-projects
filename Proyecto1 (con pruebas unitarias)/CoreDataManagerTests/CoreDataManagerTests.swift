//
//  CoreDataManagerTests.swift
//  CoreDataManagerTests
//
//  Created by Brandon Escalante on 30/10/20.
//  Copyright © 2020 Brandon Escalante. All rights reserved.
//

import XCTest
import MapKit

@testable import Proyecto1

class CoreDataManagerTests: XCTestCase {

    
    var manager : CoreDataManager!
    
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
        let totalUbicaciones = manager.getUbicacionesCount()
        
        XCTAssertEqual(totalUbicaciones, 4)
    }
    
    func testPointsInRegion() throws {
        
        let points = [
            CLLocationCoordinate2DMake(19.41785078931838, -99.17734323188405),
            CLLocationCoordinate2DMake(19.414912058231494, -99.17908236231884),
            CLLocationCoordinate2DMake(19.413146515947375, -99.17793501932367),
            CLLocationCoordinate2DMake(19.41626173625282, -99.17721936758008 )
        ]
        
        let workRegion = WorkRegion(coordinates: points, count: points.count)
        
        let ubicacionesinRegion = self.manager.getUbicaciones(workRegion: workRegion)
        let ubicacionesTotal = self.manager.getUbicaciones()
        
        var count = 0
        for ubicacion in ubicacionesTotal {
            if ubicacionesinRegion.contains(ubicacion) {
                count += 1
            }
        }
        
        XCTAssertEqual(count, ubicacionesTotal.count)
    }
    
    func testResetUbicaciones() throws {
        XCTAssertTrue(self.manager.clearUbicaciones())
    }
    
    func testCountEntrevistas() throws {
        XCTAssertEqual(self.manager.getEntrevistasCount(), 0)
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
