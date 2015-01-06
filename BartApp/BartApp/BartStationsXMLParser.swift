//
//  BartStationsXMLParser.swift
//  BartApi
//
//  Created by Michael Charkin on 1/5/15.
//  Copyright (c) 2015 FireMuzzy. All rights reserved.
//

import Foundation
import UIKit

class StationTag {
  var name:String?
  var abbr:String?
  var lat:Double?
  var lng:Double?
  var city:String?
  var etd:[EtdTag] = []
  
  init() {}
}

class EtdTag {
  var destination:String?
  var abbreviation:String?
  var estimates:[EstimateTag] = []
}

class EstimateTag {
  var minutes:Double?
  var platform:Int?
  var direction:String?
  var length:Int?
  var color:String?
  var hexcolor:String?
  var bikeflag:String?
}


protocol BartStationsXMLParserDelegate {
  func parsedStations(stations: [Station])
}

class BartStationsXMLParser: ApiXmlParser {
  let onParsedStations: (([Station]) -> Void)?
  let onError: ((NSError) -> Void)?
  
  var stationTagO: StationTag? = nil
  var stationTags: [StationTag] = []
  
  // having issues with on error being called more than once
  var wasErrorCalled = false
  
  init(url:NSURL, onParsedStations: ([Station]) -> Void, onError: (NSError) -> Void) {
    super.init(url: url)
    
    self.onParsedStations = onParsedStations
    self.onError = onError
  }
  
  override func parserDidEndDocument(parser: NSXMLParser) {
    super.parserDidEndDocument(parser)
    
    var stations: [Station] = []
    for st in self.stationTags {
      let nameO = st.name
      let abbrO = st.abbr
      let latO = st.lat
      let lngO = st.lng
      let city = st.city
      
      if(nameO != nil && abbrO != nil && latO != nil && lngO != nil) {
        var station = Station(name: nameO!, abbreviation: abbrO!, city: city, latitude: latO!, longitude: lngO!)
        stations.append(station)
      }
    }
    
    self.onParsedStations?(stations)
  }
  
  override func parse() -> Bool {
    NSLog("parsing stations")
    return super.parse()
  }
  
  override func parser(parser: NSXMLParser, foundCharacters string: String) {
    super.parser(parser, foundCharacters: string)
    
    let cleanedStr = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    
    // by stripping all the white spate and new lines, I try to skip all the empty xml noted for
    // any notes that hold no data by only children
    if(cleanedStr.isEmpty) {
      return
    }
    
    let tagO = self.currentTag
    let parentO = self.parentTag()
    switch((parentO, tagO)) {
    case (.Some("station"), .Some(let tag)): _updateStation(tag, value:string)
    default: ()
    }
  }
  
  override func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String!, qualifiedName qName: String!) {
    super.parser(parser, didEndElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName)
    
    //    NSLog("ended parsing: %@", elementName)
    
    switch elementName {
    case "station":
      if(self.stationTagO != nil) {
        self.stationTags.append(self.stationTagO!)
        self.stationTagO = nil
      }
    default: ()
    }
  }
  
  override func parser(parser: NSXMLParser!, parseErrorOccurred parseError: NSError!) {
    if let er = parseError {
      let error = er
      let error2 = parseError!
      
      NSLog("fuck you")
      NSLog("api \(self) parser \(parser) error: \(parseError!.localizedDescription)")
      assert(!self.wasErrorCalled, "on error was already called")
      self.wasErrorCalled = true
      self.onError?(parseError!)
    } else {
      NSLog("parser error: SOME SHIT HAPPENED")
      
      
      let error = NSError(domain: ERROR_DOMAIN, code: 0, userInfo: [NSLocalizedDescriptionKey: "an error happened"])
      assert(!self.wasErrorCalled, "on error was already called")
      self.wasErrorCalled = true
      self.onError?(error)
    }
  }
  
  private func _updateStation(fieldName:String, value:String) {
    if(self.stationTagO == nil) {
      self.stationTagO = StationTag()
    }
    
    switch(fieldName) {
    case "name": self.stationTagO!.name = value
    case "abbr": self.stationTagO!.abbr = value.lowercaseString
    case "gtfs_latitude": self.stationTagO!.lat = value.toDouble()
    case "gtfs_longitude": self.stationTagO!.lng = value.toDouble()
    case "city": self.stationTagO!.city = value
      
    default: ()
    }
  }
  
}