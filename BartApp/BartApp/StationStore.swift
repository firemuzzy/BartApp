//
//  StationStore.swift
//  BartApi
//
//  Created by Michael Charkin on 1/5/15.
//  Copyright (c) 2015 FireMuzzy. All rights reserved.
//

import Foundation
import BrightFutures
import CoreLocation

class DistanceFilter<T> {
  let radius: CLLocationDistance
  let coord: CLLocationCoordinate2D
  let loc: CLLocation
  let obj: T
  
  init(distance:CLLocationDistance, coord:CLLocationCoordinate2D, obj:T) {
    self.radius = distance
    self.coord = coord
    self.loc = CLLocation(coordinate: coord, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: nil)
    self.obj = obj
  }
  
  func didExit(currentCoord: CLLocationCoordinate2D) -> Bool {
    let currentLoc = CLLocation(coordinate: currentCoord, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: nil)
    let distTraveled = currentLoc.distanceFromLocation(self.loc)
    
    return distTraveled > self.radius
  }
}

class StationStore {
  var urlO: NSURL? = nil
  var _stationF: Future<[Station]>? = nil
  var _stationDictF: Future<Dictionary<String, Station>>? = nil
  
  var dFilter: DistanceFilter<Station>? = nil
  var _closestStationF: Future<Station?> = Future.succeeded(nil)
  var dFilterF: Future<DistanceFilter<Station>>? = nil
  
  
  
  private var abbrToStation = Dictionary<String,Station>(minimumCapacity: 100)
  
  var parser: BartStationsXMLParser? = nil
  
  class func distanceFilter(myCoord: CLLocationCoordinate2D, stations:[Station]) -> Double {
    if(stations.count <= 1) {
      return 0
    } else if(stations.count == 2) {
      return distanceFilter(myCoord, st1: stations[0], st2: stations[1])
    } else {
      let myLoc = CLLocation(coordinate: myCoord, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, course: 0, speed: 0, timestamp: nil)
      
      var minStation1: Station? = nil
      var minDistance1: Double = Double.infinity
      var minStation2: Station? = nil
      var minDistance2: Double = Double.infinity
      
      for station in stations {
        let stLoc = CLLocation(coordinate: myCoord, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, course: 0, speed: 0, timestamp: nil)
        let distance = myLoc.distanceFromLocation(stLoc)
        
        if(distance < minDistance1) {
          minDistance2 = minDistance1
          minDistance1 = distance
          
          minStation2 = minStation1
          minStation1 = station
        } else if(distance < minDistance2) {
          minDistance2 = distance
          minStation2 = station
        }
      }
      
      let diff = abs(minDistance1 - minDistance2)
      let distance = diff/2.0
      return distance
    }
  }
  
  class func distanceFilter(myCoord: CLLocationCoordinate2D, st1: Station, st2: Station) -> Double {
    let myLoc = CLLocation(coordinate: myCoord, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, course: 0, speed: 0, timestamp: nil)
    let st1Loc = CLLocation(coordinate: st1.coordinate(), altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: nil)
    let st2Loc = CLLocation(coordinate: st2.coordinate(), altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: nil)
    
    let distToSt1 = st1Loc.distanceFromLocation(myLoc)
    let distToSt2 = st2Loc.distanceFromLocation(myLoc)
    let diff = abs(distToSt1 - distToSt2)
    let distance = diff/2.0
    return distance
  }
  
  func configureUrl(url: NSURL) -> Void {
    // url is changes, clear the station f to clear the cache
    self._stationF = nil
    self._stationDictF = nil
    self.urlO = url
  }
  
  func stationsF() -> Future<[Station]> {
    if(self._stationF != nil) {
      return self._stationF!
    } else {
      switch(self.urlO) {
      case .Some(let url):
        self._stationF = BartApi.stations(url)
      case .None:
        self._stationF = BartApi.stations()
      }
      
      return self._stationF!
    }
  }
  
  func dummyStationsF() -> Future<[Station]> {
    return future {
      let expected12StSt = Station(name: "12th St. Oakland City Center", abbreviation: "12th", city: "Oakland", latitude: 37.803664, longitude: -122.271604)
      let expected16StSt = Station(name: "16th St. Mission", abbreviation: "16th", city: "San Francisco", latitude: 37.765062, longitude: -122.419694)
      let expectedMontSt = Station(name: "Montgomery St.", abbreviation: "mont", city: "San Francisco", latitude: 37.789256, longitude: -122.401407)
      let expectedRockSt = Station(name: "Rockridge", abbreviation: "rock", city: "Oakland", latitude: 37.844601, longitude: -122.251793)
      let expectedSFOSt = Station(name: "San Francisco Int'l Airport", abbreviation: "sfia", city: "San Francisco Int'l Airport", latitude: 37.616035, longitude: -122.392612)
      let expectedSSFSt = Station(name: "South San Francisco", abbreviation: "ssan", city: "South San Francisco", latitude: 37.664174, longitude: -122.444116)
      
      let stns = [expected12StSt,expected16StSt,expectedMontSt,expectedRockSt,expectedSFOSt,expectedSSFSt]
      return Result.Success(Box(stns))
    }
  }
  
  func dummyAbbrDictF() -> Future<Dictionary<String, Station>> {
    let funct: Future<[Station]> = self.dummyStationsF()
    
    let p: Promise<Dictionary<String, Station>> = Promise()
    
    NSLog("Is Main queue: \(NSThread.isMainThread())")
    let queue = NSThread.isMainThread() ? Queue.main : Queue.global
    
    funct.onComplete(context: queue) { res in
      switch (res) {
      case .Failure(let e):
        NSLog("error")
        p.error(e)
      case .Success(let response):
        NSLog("success")
        var dict:Dictionary<String, Station> = [:]
        for station in response.value {
          dict[station.abbreviation] = station
        }
        
        p.completeWith(Future.succeeded(dict))
      }
    }
    
    return p.future
  
//    var fut = funct.flatMap({ (stations) -> Result<Dictionary<String, Station>> in
//      var dict: Dictionary<String, Station> = [:]
//      for station in stations {
//        dict[station.abbreviation] = station
//      }
//      return Result.Success(Box(dict))
//    })
//    return fut
  }
  
  func abbrDictF() -> Future<Dictionary<String, Station>> {
    if(self._stationDictF != nil) {
      return self._stationDictF!
    } else {
      self._stationDictF = self.stationsF().map { stations -> Dictionary<String, Station> in
        var dict: Dictionary<String, Station> = [:]
        for station in stations {
          dict[station.abbreviation] = station
        }
        return dict
      }
      return self._stationDictF!
    }
  }
  
  init() {}
  
  func forAbbreviation(abbr: String) -> Future<Station?> {
    return self.abbrDictF().map { (dict) -> Station? in
      return dict[abbr]
    }
  }
  
  class var sharedInstance: StationStore {
    struct Static {
      static var instance: StationStore?
      static var token: dispatch_once_t = 0
    }
    
    dispatch_once(&Static.token) {
      //      let urlO = NSBundle.mainBundle().URLForResource("bart_stations", withExtension: "xml")
      var store = StationStore()
      //      store.configureUrl(urlO!)
      Static.instance = store
    }
    
    return Static.instance!
  }
  
}