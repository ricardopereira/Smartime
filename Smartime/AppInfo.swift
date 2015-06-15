//
//  AppInfo.swift
//  Smartime
//
//  Created by Ricardo Pereira on 15/06/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

struct AppInfo {
    
    private var _deviceID: String
    
    init() {
        _deviceID = ""
    }
    
    var deviceID: String {
        return _deviceID
    }
    
    mutating func setDeviceToken(data: NSData) {
        var deviceTokenStr = data.description
        
        var tokenRange = Range<String.Index>(start: deviceTokenStr.startIndex.successor(), end: deviceTokenStr.endIndex.predecessor())
        
        deviceTokenStr = deviceTokenStr.substringWithRange(tokenRange)
        
        tokenRange = Range<String.Index>(start: deviceTokenStr.startIndex, end: deviceTokenStr.endIndex)
        
        _deviceID = deviceTokenStr.stringByReplacingOccurrencesOfString(" ", withString: "", options: .LiteralSearch, range: tokenRange)
    }
    
}