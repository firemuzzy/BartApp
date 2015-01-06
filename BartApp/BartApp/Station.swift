
//
//  File.swift
//  BartApi
//
//  Created by Michael Charkin on 1/5/15.
//  Copyright (c) 2015 FireMuzzy. All rights reserved.
//

import Foundation
import BrightFutures
import CoreLocation

enum Direction {
  case North
  case South
  
  static func fromStr(string:String) -> Direction? {
    switch(string.lowercaseString) {
    case "north": return North
    case "south": return South
    default: return nil
    }
  }
  
  func apiStr() -> String {
    switch(self) {
    case .North: return "n"
    case .South: return "s"
    }
  }
}

let nameFld = "name"
let abbreviationFld = "abbreviation"
let latitudeFld = "latitude"
let longitudeFld = "longitude"
let cityFld = "city"

func ==(lhs: Station, rhs: Station) -> Bool {
  let neq = lhs.name == rhs.name
  let abeq = lhs.abbreviation == rhs.abbreviation
  let lateq = lhs.latitude == rhs.latitude
  let lngeq = lhs.longitude == rhs.longitude
  let ceq = lhs.city == rhs.city
  
  return neq && abeq && lateq && lngeq && ceq
}

class Station: Equatable {
  let name: String
  let abbreviation: String
  let latitude: Double
  let longitude: Double
  let city: String?
  
  init(name: String, abbreviation: String, city: String?, latitude: Double, longitude: Double) {
    self.name = name
    self.abbreviation = abbreviation
    self.latitude = latitude
    self.longitude = longitude
    self.city = city
  }
  
  func coordinate() -> CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
  }
  
  class func fetchStations() -> Future<[Station]> {
    let promise =  Promise<[Station]>()
    
    let urlStr = "FUCK" //BartHelpers.bartStationsUrl()
    let url = NSURL(string: urlStr)!
    NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, resp, error) -> Void in
      if(error != nil) {
        promise.error(error!)
      } else {
        
      }
    })
    
    return promise.future
  }
  
  //  class func buildFromCSV(filename: String) -> [Station] {
  //    let urlO = NSBundle.mainBundle().URLForResource(filename, withExtension: "csv")
  //    switch urlO {
  //      case .None:
  //        NSLog("No file found for file %@", filename)
  //        return []
  //      case .Some(let url):
  //
  //        let csv = CSV(contentsOfURL: url)
  //        var stations: [Station] = []
  //
  //        for row in csv.rows {
  //          let nameO: String? = row[nameFld]
  //          let abbreviationO: String? = row[abbreviationFld]
  //
  //          let latitudeStrO: String? = row[latitudeFld]
  //          let longitudeStrO: String? = row[longitudeFld]
  //          let latitudeO: Double? = latitudeStrO?.toDouble()
  //          let longitudeO: Double? = longitudeStrO?.toDouble()
  //
  //          if (nameO != nil && abbreviationO != nil && latitudeO != nil && longitudeO != nil) {
  //            let cityO = row[cityFld]
  //            let station = Station(name: nameO!, abbreviation: abbreviationO!, city:cityO, latitude: latitudeO!, longitude: longitudeO!)
  //            stations.append(station)
  //          }
  //        }
  //
  //        return stations
  //    }
  //  }
  
}