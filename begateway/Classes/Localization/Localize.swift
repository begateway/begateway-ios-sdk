//
//  Localized.swift
//  FittedSheetsPod
//
//  Created by Gordon Tucker on 8/11/20.
//  Copyright © 2020 Gordon Tucker. All rights reserved.
//

import UIKit

let staticKeyForLocalization = "bePaidStaticKeyForLocalization"
private class FittedSheets { }
enum Localize: String {
    case dismissPresentation
    case changeSizeOfPresentation
    case payButton
    
//    var localized: String {
//        return NSLocalizedString(self.rawValue, tableName: nil, bundle: Bundle(for: FittedSheets.self), value: "", comment: "")
//    }
    
    var localized: String {
            if let _ = UserDefaults.standard.string(forKey: staticKeyForLocalization) {} else {
                UserDefaults.standard.set("en", forKey: staticKeyForLocalization)
                UserDefaults.standard.synchronize()
            }

            let lang = UserDefaults.standard.string(forKey: staticKeyForLocalization)

        guard let path = Bundle.main.path(forResource: lang, ofType: "lproj") ?? Bundle.main.path(forResource: "en", ofType: "lproj") else { return self.rawValue }
        let bundle = Bundle(path: path)
        
        return NSLocalizedString(self.rawValue, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
extension String {
    var localized: String {
            if let _ = UserDefaults.standard.string(forKey: staticKeyForLocalization) {} else {
                UserDefaults.standard.set("en", forKey: staticKeyForLocalization)
                UserDefaults.standard.synchronize()
            }

            let lang = UserDefaults.standard.string(forKey: staticKeyForLocalization)
        
        let bundleT = Bundle.init(for: FittedSheets.self)
        let path = bundleT.path(forResource: lang, ofType:"lproj")
        
        if (path != nil) {
            let bundle = Bundle(path: path!)
            return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
        }
        
        guard let path = Bundle.main.path(forResource: lang, ofType: "lproj") ?? Bundle.main.path(forResource: "en", ofType: "lproj") else { return self }
        let bundle = Bundle(path: path)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
class LocalizedString{
    static func LocalizedString(value: String, _ arguments: CVarArg...) -> String {
        return value.localized
    }
}
