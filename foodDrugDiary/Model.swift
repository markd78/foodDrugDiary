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
    var currentFilter:Filter = Filter()

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
    
    public func setFilter(filter:Filter)
    {
        self.currentFilter = filter
        applyFilter()
    }
    
    func entryFilter(entry:Entry) -> Bool {
        
        if (entry.entryType == EntryType.food && !currentFilter.isFood)
        {
            return false
        }
        
        if (entry.entryType == EntryType.symptoms && !currentFilter.isSymptom)
        {
            return false
        }
        
        
        if (entry.entryType == EntryType.meds && !currentFilter.isMeds)
        {
            return false
        }
        
        
        if (currentFilter.useDate  && (currentFilter.fromDate > entry.date || currentFilter.toDate < entry.date))
        {
            return false
        }
        
        return true
        
    }
    
    public func resetFilter()
    {
        self.currentFilter = Filter()
    }
    
    public func applyFilter()
    {
        
        
        displayedEntries = displayedEntries.filter(entryFilter)
    }
    
}