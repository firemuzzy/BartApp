//
//  Constants.swift
//  BartApi
//
//  Created by Michael Charkin on 1/5/15.
//  Copyright (c) 2015 FireMuzzy. All rights reserved.
//

import Foundation

let ERROR_DOMAIN = "com.firemuzzy.bartrunner"
let ERROR_CODE_NO_TRAVEL_TIME = 31
let ERROR_CODE_TIMEOUT = 32

let TIMEOUT = 1.0

let BART_API_KEY = "MW9S-E7SL-26DU-VV8V"
let BART_API_URL = "http://api.bart.gov/api/"

let TIMEOUT_ERROR = NSError(domain: ERROR_DOMAIN, code: ERROR_CODE_TIMEOUT, userInfo: [NSLocalizedDescriptionKey: "operation timed out"])