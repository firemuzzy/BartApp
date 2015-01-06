//
//  BartApi.swift
//  BartApi
//
//  Created by Michael Charkin on 1/5/15.
//  Copyright (c) 2015 FireMuzzy. All rights reserved.
//

import Foundation
import BrightFutures


class BartApi {
  
  class func stations(url: NSURL) -> Future<[Station]> {
    let p = Promise<[Station]>()
    
    NSLog("parsing: \(  url)")
    let parser = BartStationsXMLParser(url: url, onParsedStations: { (stations) -> Void in
      NSLog("finished fetching \(stations.count) stations from: \(url) promise complete: \(p.future.isCompleted)")
      assert(!p.future.isCompleted, "should not have been completeld yet")
      p.success(stations)
      }, onError: { (error) -> Void in
        NSLog("failed fetching stations from: \(url) because:\(error.localizedDescription) promise complete:\(p.future.isCompleted) success:\(p.future.isSuccess) failed:\(p.future.isFailure)")
        assert(!p.future.isCompleted, "should not have been completeld yet")
        p.error(error)
    })
    parser.parse()
    
    return p.future
  }
  
  class func stations() -> Future<[Station]> {
    let urlO = NSURL(string: BartHelpers.bartStationsUrl())
    switch(urlO) {
    case .Some(let url): return self.stations(url)
    case .None:
      let error = NSError(domain: ERROR_DOMAIN, code: 0, userInfo: [NSLocalizedDescriptionKey: "not a valid url"])
      return Future.failed(error)
    }
  }
}