//
//  Model.swift
//  foodDrugDiary
//
//  Created by Mark Davies on 6/18/15.
//  Copyright (c) 2015 Comantis LLC. All rights reserved.
//

import Foundation

public class Model {

    init()
    {
        let entriesData = NSUserDefaults.standardUserDefaults().objectForKey("entries") as? NSData
        
        if let entriesData = entriesData {
            self.allEntries = (NSKeyedUnarchiver.unarchiveObjectWithData(entriesData) as? [Entry])!
            
            }
        else {
            allEntries = []
        }
    }
    
    static let sharedInstance = Model()
    
    var allEntries = [Entry]()
    var displayedEntries = [Entry]()

    public func addNewEntry(entry:Entry)
    {
        allEntries.append(entry)
        self.saveEntries()
    }
    
    public func saveEntries()
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject( NSKeyedArchiver.archivedDataWithRootObject(allEntries) , forKey: "entries")
    }
    
}