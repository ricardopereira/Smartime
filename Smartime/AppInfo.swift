//
//  AppInfo.swift
//  Smartime
//
//  Created by Ricardo Pereira on 15/06/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

protocol DeviceTokenContainer {
    var deviceToken: String { get set }
}

struct AppInfo {
    
    private var internalDeviceToken: String
    
    init() {
        internalDeviceToken = ""
    }
    
    var deviceToken: String {
        return internalDeviceToken
    }
    
    mutating func setDeviceToken(data: NSData) {
        var deviceTokenStr = data.description
        
        var tokenRange = Range<String.Index>(start: deviceTokenStr.startIndex.successor(), end: deviceTokenStr.endIndex.predecessor())
        
        deviceTokenStr = deviceTokenStr.substringWithRange(tokenRange)
        
        tokenRange = Range<String.Index>(start: deviceTokenStr.startIndex, end: deviceTokenStr.endIndex)
        
        internalDeviceToken = deviceTokenStr.stringByReplacingOccurrencesOfString(" ", withString: "", options: .LiteralSearch, range: tokenRange)
    }
    
}