//
//  BartHelpers.swift
//  BartApi
//
//  Created by Michael Charkin on 1/5/15.
//  Copyright (c) 2015 FireMuzzy. All rights reserved.
//

import Foundation

class BartHelpers {
  
  class func bartRoutesUrl() -> String {
    return "\(BART_API_URL)route.aspx?cmd=routes&key=\(BART_API_KEY)"
  }
  
  class func bartStationsUrl() -> String {
    return "\(BART_API_URL)stn.aspx?cmd=stns&key=\(BART_API_KEY)"
  }
  
  class func departUrl(fromStation:Station, toStation:Station) -> String {
    return self.departUrl(fromStation.abbreviation, toAbbr: toStation.abbreviation)
  }
  class func departUrl(fromAbbr:String, toAbbr:String) -> String {
    return "\(BART_API_URL)sched.aspx?cmd=depart&orig=\(fromAbbr)&dest=\(toAbbr)&date=now&b=0&a=4&key=\(BART_API_KEY)"
  }
  
  class func estimatesUrl(stationAbbr: String, direction: Direction?) -> String {
    if(direction != nil) {
      let str = "\(BART_API_URL)etd.aspx?cmd=etd&orig=\(stationAbbr)&dir=\(direction!.apiStr())&key=\(BART_API_KEY)"
      return str
    } else {
      let str = "\(BART_API_URL)etd.aspx?cmd=etd&orig=\(stationAbbr)&key=\(BART_API_KEY)"
      return str
    }
  }
  
}