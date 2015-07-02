//
//  Filter.swift
//  foodDrugDiary
//
//  Created by Mark Davies on 7/2/15.
//  Copyright (c) 2015 Comantis LLC. All rights reserved.
//

import Foundation

public class Filter : NSObject
{
    public var useDate:Bool = false
    public var fromDate:NSDate = NSDate.distantPast() as! NSDate
    public var toDate:NSDate = NSDate.distantFuture() as! NSDate
    public var isFood:Bool = true
    public var isMeds:Bool = true
    public var isSymptom:Bool = true
}