//
//  ApiXmlParser.swift
//  BartApi
//
//  Created by Michael Charkin on 1/5/15.
//  Copyright (c) 2015 FireMuzzy. All rights reserved.
//

import Foundation

class ApiXmlParser: NSObject, NSXMLParserDelegate, NSURLSessionDataDelegate {
  let url: NSURL
  var parser: NSXMLParser?
  
  var dlTask: NSURLSessionDataTask?
  
  var parentTagStack:[String] = []
  var currentTag:String? = nil
  
  let mutableData: NSMutableData = NSMutableData()
  
  init(url: NSURL) {
    self.url = url
  }
  
  func parse() -> Bool {
    let sessionConf = NSURLSessionConfiguration.defaultSessionConfiguration()
    let session = NSURLSession(configuration: sessionConf, delegate: self, delegateQueue:nil)
    
    let request = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: TIMEOUT)
    self.dlTask = session.dataTaskWithRequest(request)
    self.dlTask?.resume()
    
    return true
  }
  
  func parentTag() -> String? {
    return self.parentTagStack.last
  }
  
  // **************************
  // xml downloading delegates
  func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
    NSLog("Recieved from: \(dataTask.response?.URL?.absoluteString)")
    
    self.mutableData.appendData(data)
  }
  
  func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
    if let err = error {
      self.parser = NSXMLParser()
      self.parser(self.parser, parseErrorOccurred: err)
    } else {
      let data = NSData(data: self.mutableData)
      var parserBuilder = NSXMLParser(data: data)
      parserBuilder.shouldProcessNamespaces = false
      parserBuilder.shouldReportNamespacePrefixes = false
      parserBuilder.shouldResolveExternalEntities = false
      parserBuilder.delegate = self
      
      self.parser = parserBuilder
      parserBuilder.parse()
    }
  }
  // END xml downloading delegates
  // **************************
  
  private func updateCurrentTagWith(newTag:String) {
    //    NSLog("ApiXmlParser before updateCurrentTagWith %@ current:%@", newTag, self.currentTag.getOrElse("nil"))
    
    // set the last current tag as the parent
    if(self.currentTag != nil) {
      self.parentTagStack.append(self.currentTag!)
    }
    // update the current tag
    self.currentTag = newTag
    
    //    NSLog("ApiXmlParser after updateCurrentTagWith %@ current:%@", newTag, self.currentTag.getOrElse("nil"))
  }
  
  private func undoCurrentTag(tag:String) {
    //    NSLog("ApiXmlParser before undoCurrentTag %@, current:%@", tag, self.currentTag.getOrElse("nil"))
    
    // the last parent tag becomes the current tag
    let last = self.parentTagStack.last
    //    NSLog("ApiXmlParser during undoCurrentTag %@, last:%@", tag, last.getOrElse("nil"))
    
    self.currentTag = last
    
    if(!self.parentTagStack.isEmpty) {
      self.parentTagStack.removeLast()
    }
    
    //    NSLog("ApiXmlParser after undoCurrentTag %@, current:%@", tag, self.currentTag.getOrElse("nil"))
  }
  
  func parserDidStartDocument(parser: NSXMLParser) {
  }
  
  func parserDidEndDocument(parser: NSXMLParser) {
  }
  
  func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
    self.updateCurrentTagWith(elementName)
  }
  
  func parser(parser: NSXMLParser!, foundAttributeDeclarationWithName attributeName: String!, forElement elementName: String!, type: String!, defaultValue: String!) {
  }
  
  func parser(parser: NSXMLParser, foundCharacters string: String) {
  }
  
  func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String!, qualifiedName qName: String!) {
    self.undoCurrentTag(elementName)
  }
  
  func parser(parser: NSXMLParser!, parseErrorOccurred parseError: NSError!) {
    
  }
  
  deinit {
    NSLog("de initializes")
  }
  
}
