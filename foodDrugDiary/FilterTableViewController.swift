//
//  FilterTableViewController.swift
//  foodDrugDiary
//
//  Created by Mark Davies on 7/2/15.
//  Copyright (c) 2015 Comantis LLC. All rights reserved.
//

import UIKit

protocol FilterChangedDelegate{
    func filterChanged()
}

class FilterTableViewController: UITableViewController, TimeChangedViewController {

    var currentFilter:Filter = Filter()
    var delegate:FilterChangedDelegate?
    
    func timeChanged(date:NSDate,isFrom:Bool)
    {
        if (isFrom)
        {
            currentFilter.fromDate = date
        }
        else
        {
            currentFilter.toDate = date
        }
    }
    @IBAction func cancelButtonPressed(sender: AnyObject) {
         self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func applyFilterPressed(sender: AnyObject) {
        
        
        Model.sharedInstance.setFilter(currentFilter)
        Model.sharedInstance.applyFilter()
        
        delegate?.filterChanged()
        
         self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
        if (indexPath.section == 0)
        {
            if (indexPath.row == 0)
            {
                if (currentFilter.useDate)
                {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }
                else
                {
                    cell.accessoryType = UITableViewCellAccessoryType.None;
                }
            }
            else if (indexPath.row == 1)
            {
                let dateFormatter = NSDateFormatter()//3
                
                var theDateFormat = NSDateFormatterStyle.ShortStyle //5
                let theTimeFormat = NSDateFormatterStyle.ShortStyle//6
                
                dateFormatter.dateStyle = theDateFormat//8
                dateFormatter.timeStyle = theTimeFormat//9
                cell.detailTextLabel?.text = dateFormatter.stringFromDate(currentFilter.fromDate)
                
                if (!currentFilter.useDate)
                {
                    cell.userInteractionEnabled = false
                    cell.backgroundColor = UIColor.lightGrayColor()
                }
                else
                {
                    cell.userInteractionEnabled = true
                    cell.backgroundColor = UIColor.whiteColor()
                }
                
            }
            else if (indexPath.row == 2)
            {
                let dateFormatter = NSDateFormatter()//3
                
                var theDateFormat = NSDateFormatterStyle.ShortStyle //5
                let theTimeFormat = NSDateFormatterStyle.ShortStyle//6
                
                dateFormatter.dateStyle = theDateFormat//8
                dateFormatter.timeStyle = theTimeFormat//9
                cell.detailTextLabel?.text = dateFormatter.stringFromDate(currentFilter.toDate)
                
                if (!currentFilter.useDate)
                {
                    cell.userInteractionEnabled = false
                    cell.backgroundColor = UIColor.lightGrayColor()
                }
                else
                {
                    cell.userInteractionEnabled = true
                    cell.backgroundColor = UIColor.whiteColor()
                }
            }
        }
        
        if (indexPath.section == 1)
        {
            if (indexPath.row == 0)
            {
                if (currentFilter.isMeds )
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
                if (currentFilter.isFood )
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
                if (currentFilter.isSymptom )
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
    
    @IBAction func resetAllPressed(sender: AnyObject) {
        
        self.currentFilter = Filter()
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
        if (indexPath.section == 0)
        {
            if (indexPath.row == 0)
            {
                if (!currentFilter.useDate)
                {
                    // add some default dates
                    let today = NSDate()
                    let lastWeek = today.dateByAddingTimeInterval(-7*24 * 60 * 60)
                    self.currentFilter.fromDate = lastWeek
                    self.currentFilter.toDate = today
                }
                else
                {
                    self.currentFilter.fromDate = NSDate.distantPast() as! NSDate
                    self.currentFilter.toDate = NSDate.distantFuture() as! NSDate
                }
                
                currentFilter.useDate = !currentFilter.useDate
                
            }
        }
        else if (indexPath.section == 1)
        {
            if (indexPath.row == 0)
            {
                currentFilter.isMeds = !currentFilter.isMeds
            }
            else if (indexPath.row == 1)
            {
                currentFilter.isFood = !currentFilter.isFood
            }
            else if (indexPath.row == 2)
            {
                currentFilter.isSymptom = !currentFilter.isSymptom
            }
        }
        
        if (indexPath.section == 2)
        {
            self.currentFilter = Filter()
        }
        
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDateFromSegue"
        {
            if let destinationVC = segue.destinationViewController as? SetTimeViewController{
                destinationVC.date = currentFilter.fromDate
                destinationVC.isFrom = true
                destinationVC.delegate = self
            }
        }
        
        if segue.identifier == "ShowDateToSegue"
        {
            if let destinationVC = segue.destinationViewController as? SetTimeViewController{
                destinationVC.date = currentFilter.toDate
                destinationVC.isFrom = false
                destinationVC.delegate = self
            }
        }
    }
}
