//
//  SetTimeViewController.swift
//  foodDrugDiary
//
//  Created by Mark Davies on 7/2/15.
//  Copyright (c) 2015 Comantis LLC. All rights reserved.
//

import UIKit

protocol TimeChangedViewController{
    func timeChanged(date:NSDate,isFrom:Bool)
}

class SetTimeViewController: UIViewController {

    var delegate:TimeChangedViewController?
    var date:NSDate = NSDate()
    var isFrom:Bool = true
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewWillAppear(animated: Bool) {
        self.datePicker.date = date
    }
    
    @IBAction func datePickerChanged(sender: AnyObject) {
        
        self.delegate?.timeChanged(datePicker.date, isFrom: isFrom)
        
    }
}
