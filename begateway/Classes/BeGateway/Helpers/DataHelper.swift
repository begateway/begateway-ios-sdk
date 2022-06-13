//
//  DataHelper.swift
//  oodymate
//
//  Created by admin on 02/12/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

class DataHelper {
    class func getValue<T> (value: T?, defaultValue: T) -> T {
        if value != nil {
            return value!
        } else {
            return defaultValue
        }
    }
    
//    class func getLocalizeValue (value: String?, defaultValue: String) -> String {
//        if value != nil {
//            return NSLocalizedString(value!, comment: "")
//        } else {
//            return defaultValue.isEmpty ? "" : NSLocalizedString(defaultValue, comment: "")
//        }
//    }
    
    class func getLocalizeValue (value: String?, defaultValue: String? = nil) -> String? {
        if value != nil {
            return NSLocalizedString(value!, comment: "")
        } else {
            return defaultValue != nil && !defaultValue!.isEmpty ? NSLocalizedString(defaultValue!, comment: ""): nil
        }
    }
    
    class func setValue<T> (value: T?, item: inout T?, defaultValue: T? = nil) {
        if value != nil {
            item = value!
        } else {
            item = defaultValue
        }
    }
    
    class func implode (glue: String, items: [String?], defaultValue: String? = nil) -> String {
        var list: String = ""
        var counter: Int = 0
        
        for index in 0..<items.count {
            if items[index] != nil {
                
                if counter != 0 {
                    list += glue
                }
                
                list += NSLocalizedString(items[index]!, comment: "")
                counter += 1
            }
        }
        
        return list.isEmpty ? (defaultValue != nil ? defaultValue! : "") : list
    }
    
    class func implode (glue: String, items: [String?], source: inout String?, defaultValue: String? = nil) {
        source = self.implode(glue: glue, items: items, defaultValue: defaultValue)
    }
}
