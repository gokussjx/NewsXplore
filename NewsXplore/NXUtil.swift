//
//  NXUtil.swift
//  NewsXplore
//
//  Created by Bidyut Mukherjee on 4/17/17.
//  Copyright © 2017 NewsXplore. All rights reserved.
//

import Foundation

public final class NXUtil {
    
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
