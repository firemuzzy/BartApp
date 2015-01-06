//
//  StationStoreTests.swift
//  BartApi
//
//  Created by Michael Charkin on 1/5/15.
//  Copyright (c) 2015 FireMuzzy. All rights reserved.
//

import UIKit
import XCTest
import CoreLocation

class StationStoreTests: XCTestCase {
  let store: StationStore = StationStore()
  
  override func setUp() {
    super.setUp()
    
    let urlO = NSBundle.mainBundle().URLForResource("sample_stations", withExtension: "xml")
    store.configureUrl(urlO!)
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testStationsF() {
    let fut = store.stationsF()
    
    if let stations = fut.forced(1)?.value {
      
      let isValidCount = stations.count > 0
      XCTAssertTrue(isValidCount, "no staions")
      
      XCTAssertEqual(stations.count, 6, "wrong number of estimates")
      
      let expected12StSt = Station(name: "12th St. Oakland City Center", abbreviation: "12th", city: "Oakland", latitude: 37.803664, longitude: -122.271604)
      let expected16StSt = Station(name: "16th St. Mission", abbreviation: "16th", city: "San Francisco", latitude: 37.765062, longitude: -122.419694)
      let expectedMontSt = Station(name: "Montgomery St.", abbreviation: "mont", city: "San Francisco", latitude: 37.789256, longitude: -122.401407)
      let expectedRockSt = Station(name: "Rockridge", abbreviation: "rock", city: "Oakland", latitude: 37.844601, longitude: -122.251793)
      let expectedSFOSt = Station(name: "San Francisco Int'l Airport", abbreviation: "sfia", city: "San Francisco Int'l Airport", latitude: 37.616035, longitude: -122.392612)
      let expectedSSFSt = Station(name: "South San Francisco", abbreviation: "ssan", city: "South San Francisco", latitude: 37.664174, longitude: -122.444116)
      
      let found12thStSt = stations[0]
      let found16StSt = stations[1]
      let foundMontSt = stations[2]
      let foundRockSt = stations[3]
      let foundSFOSt = stations[4]
      let foundSSFSt = stations[5]
      
      XCTAssertNotNil(found12thStSt, "")
      XCTAssertNotNil(found16StSt, "")
      XCTAssertNotNil(foundMontSt, "")
      XCTAssertNotNil(foundRockSt, "")
      XCTAssertNotNil(foundSFOSt, "")
      XCTAssertNotNil(foundSSFSt, "")
      
      XCTAssertEqual(found12thStSt, expected12StSt, "stations did not match")
      XCTAssertEqual(found16StSt, expected16StSt, "stations did not match")
      XCTAssertEqual(foundMontSt, expectedMontSt, "stations did not match")
      XCTAssertEqual(foundRockSt, expectedRockSt, "stations did not match")
      XCTAssertEqual(foundSFOSt, expectedSFOSt, "stations did not match")
      XCTAssertEqual(foundSSFSt, expectedSSFSt, "stations did not match")
    } else {
      XCTFail("should have succeded")
    }
  }
  
  func testAbbrs() {
    let fut = store.stationsF()
    
    if let stations = fut.forced(1)?.value {
      let isValidCount = stations.count > 0
      XCTAssertTrue(isValidCount, "no staions")
    }
    
    var dictO: Dictionary<String, Station>? = nil
    
    if let dictValue = store.dummyAbbrDictF().forced(1)?.value {
      dictO = dictValue
    } else {
      XCTFail("should have succeded")
      return
    }
    
    XCTAssertTrue(dictO != nil, "no values in dict")
    let dict = dictO!
    
    let isValidCount = dict.count > 0
    XCTAssertTrue(isValidCount, "no values in dict")
    
    let expected12StSt = Station(name: "12th St. Oakland City Center", abbreviation: "12th", city: "Oakland", latitude: 37.803664, longitude: -122.271604)
    let expected16StSt = Station(name: "16th St. Mission", abbreviation: "16th", city: "San Francisco", latitude: 37.765062, longitude: -122.419694)
    let expectedMontSt = Station(name: "Montgomery St.", abbreviation: "mont", city: "San Francisco", latitude: 37.789256, longitude: -122.401407)
    let expectedRockSt = Station(name: "Rockridge", abbreviation: "rock", city: "Oakland", latitude: 37.844601, longitude: -122.251793)
    let expectedSFOSt = Station(name: "San Francisco Int'l Airport", abbreviation: "sfia", city: "San Francisco Int'l Airport", latitude: 37.616035, longitude: -122.392612)
    let expectedSSFSt = Station(name: "South San Francisco", abbreviation: "ssan", city: "South San Francisco", latitude: 37.664174, longitude: -122.444116)
    
    let found12thStSt = dict[expected12StSt.abbreviation]
    let found16StSt = dict[expected16StSt.abbreviation]
    let foundMontSt = dict[expectedMontSt.abbreviation]
    let foundRockSt = dict[expectedRockSt.abbreviation]
    let foundSFOSt = dict[expectedSFOSt.abbreviation]
    let foundSSFSt = dict[expectedSSFSt.abbreviation]
    
    XCTAssertNotNil(found12thStSt, "")
    XCTAssertNotNil(found16StSt, "")
    XCTAssertNotNil(foundMontSt, "")
    XCTAssertNotNil(foundRockSt, "")
    XCTAssertNotNil(foundSFOSt, "")
    XCTAssertNotNil(foundSSFSt, "")
    
    if(found12thStSt != nil) {
      XCTAssertEqual(found12thStSt!, expected12StSt, "stations did not match")
    }
    if(found16StSt != nil) {
      XCTAssertEqual(found16StSt!, expected16StSt, "stations did not match")
    }
    if(foundMontSt != nil) {
      XCTAssertEqual(foundMontSt!, expectedMontSt, "stations did not match")
    }
    if(foundRockSt != nil) {
      XCTAssertEqual(foundRockSt!, expectedRockSt, "stations did not match")
    }
    if(foundSFOSt != nil) {
      XCTAssertEqual(foundSFOSt!, expectedSFOSt, "stations did not match")
    }
    if(foundSSFSt != nil) {
      XCTAssertEqual(foundSSFSt!, expectedSSFSt, "stations did not match")
    }
  }
  
}