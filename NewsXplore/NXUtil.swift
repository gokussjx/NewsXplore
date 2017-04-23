//
//  NXUtil.swift
//  NewsXplore
//
//  Created by Bidyut Mukherjee on 4/17/17.
//  Copyright © 2017 NewsXplore. All rights reserved.
//

import Foundation

public final class NXUtil {
    
    // Server URL
    // TODO: Change to dev.newsxplore.com
    static let baseUrl = "http://localhost:8084"
//    static let baseUrl = "http://10.0.9.182:8084"
//    static let baseUrl = "http://192.168.0.103:8084"
    
    static let htmlHead = "<!DOCTYPE html> \r\n "
        + "<html> \r\n "
        + "<head> \r\n "
        + "<style> \r\n "
        + "img { \r\n "
        + "display: block; \r\n "
        + "margin: 0 auto; \r\n "
        + "max-width: 100%; \r\n "
        + "height: auto; \r\n "
        + "} \r\n "
        + "#entities{ \r\n"
        + "display: none; \r\n"
        + "} \r\n"
        + "p{ \r\n"
        + "text-align: justify; \r\n"
        + "} \r\n"
        + "</style> \r\n "
        + "</head> \r\n "
        + "<body> \r\n"
    
    static let htmlEnd = "</body> \r\n "
        + "</html> "
    
    class func dateToReadableString(date: Date?) -> String {
        if let date = date {
            
            let formatterDate = DateFormatter()
            formatterDate.dateStyle = DateFormatter.Style.long
            
            let formatterTime = DateFormatter()
            formatterTime.timeStyle = DateFormatter.Style.medium
            
            let returnTime = formatterTime.string(from: date)
            let returnDateString = formatterDate.string(from: date) + " at " + returnTime
            
            return returnDateString
        }
        
        return "-"
    }
}

// Returns an array of unique ServerResultDictionary, based on srcUrl
extension Array where Element: Equatable {
    var unique: [Element] {
        
        var uniqueValues: [Element] = []
        var uniqueUrls: [String] = []
        var uniqueNames: [String] = []
        
        forEach { item in
            if item is ServerResultDictionary {
                if let srcUrl = (item as? ServerResultDictionary)?.srcUrl {
                    if !uniqueUrls.contains(srcUrl) {
                        uniqueUrls += [srcUrl]
                        uniqueValues += [item]
                    }
                }
//                return
            } else if item is EntityExtracted {
                if let name = (item as? EntityExtracted)?.name {
                    if !uniqueNames.contains(name) {
                        uniqueNames += [name]
                        uniqueValues += [item]
                    }
                }
            }
//            if !uniqueValues.contains(item) {
//                uniqueValues += [item]
//            }
        }
        return uniqueValues
    }
}
