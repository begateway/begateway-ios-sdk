//
//  BrowserInfoProvider.swift
//  begateway
//
//  Created by Igor on 20.09.2022.
//

import Foundation
import UIKit
import WebKit


class BrowserInfoProvider {
    
    class func getBrowserInfo() -> Browser {
        let wv = WKWebView()
        let screenDepth = 32
        let headers = "application/json, text/plain, */*"
        
        let screenSize = UIScreen.main.bounds
        let width = Int(screenSize.width)
        let height = Int(screenSize.height)
        let langStr = Locale.current.languageCode
        let javaEnabled = wv.configuration.preferences.javaScriptEnabled
        let userAgent = wv.value(forKey: "userAgent") as! NSString as String
        let timeZoneSeconds = TimeZone.current.secondsFromGMT()
        let timeZone = Int(Float(timeZoneSeconds) / 60.0)
        let timeZoneName = TimeZone.current.identifier
        
        let browserInfo = Browser(acceptHeader: headers, screenWidth: width, screenHeight: height, screenColorDepth: screenDepth, windowHeight: height, windowWidth: width, language: langStr, javaEnabled: javaEnabled, userAgent: userAgent, timeZone: timeZone, timeZoneName: timeZoneName)
        
        return browserInfo
    }
    
    
}

class Browser: Codable {
    let acceptHeader: String?
    let screenWidth, screenHeight, screenColorDepth, windowHeight: Int?
    let windowWidth: Int?
    let language: String?
    let javaEnabled: Bool
    let userAgent: String?
    let timeZone: Int?
    let timeZoneName: String?

    enum CodingKeys: String, CodingKey {
        case acceptHeader = "accept_header"
        case screenWidth = "screen_width"
        case screenHeight = "screen_height"
        case screenColorDepth = "screen_color_depth"
        case windowHeight = "window_height"
        case windowWidth = "window_width"
        case language
        case javaEnabled = "java_enabled"
        case userAgent = "user_agent"
        case timeZone = "time_zone"
        case timeZoneName = "time_zone_name"
    }

    init(acceptHeader: String?, screenWidth: Int?, screenHeight: Int?, screenColorDepth: Int?, windowHeight: Int?, windowWidth: Int?, language: String?, javaEnabled: Bool, userAgent: String?, timeZone: Int?, timeZoneName: String?) {
        self.acceptHeader = acceptHeader
        self.screenWidth = screenWidth
        self.screenHeight = screenHeight
        self.screenColorDepth = screenColorDepth
        self.windowHeight = windowHeight
        self.windowWidth = windowWidth
        self.language = language
        self.javaEnabled = javaEnabled
        self.userAgent = userAgent
        self.timeZone = timeZone
        self.timeZoneName = timeZoneName
    }
}


