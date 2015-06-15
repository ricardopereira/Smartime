//
//  AppSettings.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import UIKit

struct AppSettings {
    
    let defaults: NSUserDefaults
    
    init(defaults: NSUserDefaults) {
        self.defaults = defaults
    }
    
    func getVersion() -> String {
        if let version = defaults.stringForKey("Version") {
            return version
        }
        // First time
        let version = "1.0"
        setVersion(version)
        return version
    }
    
    func setVersion(value: String) {
        defaults.setObject(value, forKey: "Version")
    }
}
