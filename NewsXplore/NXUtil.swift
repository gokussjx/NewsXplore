//
//  NXUtil.swift
//  NewsXplore
//
//  Created by Bidyut Mukherjee on 4/17/17.
//  Copyright © 2017 NewsXplore. All rights reserved.
//

import Foundation

public final class NXUtil {
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
