//
//  EntryViewController.swift
//  foodDrugDiary
//
//  Created by Mark Davies on 6/19/15.
//  Copyright (c) 2015 Comantis LLC. All rights reserved.
//

import UIKit

public class EntryViewController: UITableViewController {

    @IBOutlet var dateTime:UIDatePicker?
    @IBOutlet var textView:UITextView?
    var entryType:EntryType = EntryType.food
    
    public var entryEditing:Entry?;
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tabBarController?.tabBar.hidden = true;
        
        if ((entryEditing) != nil)
        {
            dateTime?.setDate(entryEditing!.date, animated: false);
            textView?.text = entryEditing?.textDesc
            entryType = entryEditing!.entryType
            
        }
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        println("You clicked the button")
    }
    
    
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
        if (indexPath.section == 1)
        {
            if (indexPath.row == 0)
            {
                if (entryType == EntryType.meds)
                {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }
                else
                {
                    cell.accessoryType = UITableViewCellAccessoryType.None;
                }
                
            }
            
            if (indexPath.row == 1)
            {
                if (entryType == EntryType.food)
                {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }
                else
                {
                    cell.accessoryType = UITableViewCellAccessoryType.None;
                }
                
            }
            
            if (indexPath.row == 2)
            {
                if (entryType == EntryType.symptoms)
                {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }
                else
                {
                    cell.accessoryType = UITableViewCellAccessoryType.None;
                }
                
            }
        }
        
        return cell;
    }
    
    override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
        
        if (indexPath.section == 1)
        {
            if (indexPath.row == 0)
            {
               entryType = EntryType.meds
            }
            
            if (indexPath.row == 1)
            {
                entryType = EntryType.food
            }
            
            if (indexPath.row == 2)
            {
                entryType = EntryType.symptoms
            }
        }
        
        self.tableView.reloadData();
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        
        if (entryEditing == nil)
        {
            var entry:Entry =  Entry()
            entry.date = self.dateTime!.date
            entry.textDesc = self.textView!.text
        
            entry.entryType = self.entryType
        
            Model.sharedInstance.addNewEntry(entry)
        }
        else
        {
            entryEditing!.date = self.dateTime!.date
            entryEditing!.textDesc = self.textView!.text
            entryEditing!.entryType = self.entryType
            
            Model.sharedInstance.saveEntries()
        }
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
}
