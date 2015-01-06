//
//  RichString.swift
//  BartApi
//
//  Created by Michael Charkin on 1/5/15.
//  Copyright (c) 2015 FireMuzzy. All rights reserved.
//

import Foundation

extension String {
  func toDouble() -> Double? {
    return NSNumberFormatter().numberFromString(self)!.doubleValue
  }
  
  func length() -> Int {
    return countElements(self)
  }
  
  func trim() -> String {
    return self.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
  }
  
  func substring(location:Int, length:Int) -> String! {
    return (self as NSString).substringWithRange(NSMakeRange(location, length))
  }
  
  subscript(index: Int) -> String! {
    get {
      return self.substring(index, length: 1)
    }
  }
  
  func location(other: String) -> Int {
    return (self as NSString).rangeOfString(other).location
  }
  
  func contains(other: String) -> Bool {
    return (self as NSString).containsString(other)
  }
  
  // http://stackoverflow.com/questions/6644004/how-to-check-if-nsstring-is-contains-a-numeric-value
  func isNumeric() -> Bool {
    return (self as NSString).rangeOfCharacterFromSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).location == NSNotFound
  }
}