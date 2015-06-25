//
//  Entry.swift
//  foodDrugDiary
//
//  Created by Mark Davies on 6/18/15.
//  Copyright (c) 2015 Comantis LLC. All rights reserved.
//

import UIKit

public enum EntryType: String {
    // enumeration definition goes here
    case meds = "Med"
    case food = "Food"
    case symptoms = "Symptom"
}

public class Entry : NSObject, NSCoding {

    public var date:NSDate = NSDate()
    
    public var textDesc = ""
    
    public var entryType:EntryType!
    
    public override init() {}
    
    required public init(coder aDecoder: NSCoder) {
        if let date = aDecoder.decodeObjectForKey("date") as? NSDate {
            self.date = date
        }
        if let textDesc = aDecoder.decodeObjectForKey("textDesc") as? String {
            self.textDesc = textDesc
        }
        if let entryTypeStr = aDecoder.decodeObjectForKey("entryType") as? String {
            self.entryType = EntryType(rawValue: entryTypeStr)
        }
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
         aCoder.encodeObject(date, forKey: "date")
        aCoder.encodeObject(textDesc, forKey: "textDesc")
        aCoder.encodeObject(entryType.rawValue, forKey: "entryType")
    }
    
}
