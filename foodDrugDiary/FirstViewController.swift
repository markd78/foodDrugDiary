//
//  FirstViewController.swift
//  foodDrugDiary
//
//  Created by Mark Davies on 6/18/15.
//  Copyright (c) 2015 Comantis LLC. All rights reserved.
//

import UIKit

class FirstViewController: UITableViewController, UISearchBarDelegate  {

    let model = Model.sharedInstance;
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        navigationController?.setNavigationBarHidden(false, animated: false) //or animated: false

       self.searchBar.returnKeyType = UIReturnKeyType.Done
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        // Filter the array using the filter method
        model.displayedEntries = model.allEntries.filter({( entry: Entry) -> Bool in
            let isAll:Bool = (scope == "All");
            let isScopeMatch:Bool = (entry.entryType.rawValue == scope);
            let categoryMatch:Bool = (isAll || isScopeMatch);
            let stringMatch = entry.textDesc.rangeOfString(searchText);
            let allow = categoryMatch && (searchText == "" || stringMatch != nil);
            return allow;
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
         self.filterContentForSearchText("", scope: "All")
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBarHidden = false;
         self.tabBarController?.tabBar.hidden = false;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func  tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return Model.sharedInstance.displayedEntries.count;
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterContentForSearchText(searchText, scope: "All")
        self.tableView.reloadData()
        
        // The user clicked the [X] button or otherwise cleared the text.
        if(count(searchText) == 0 ) {
            
            var dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
               self.searchBar.resignFirstResponder()
            })
            
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.filterContentForSearchText("", scope: "All")
        self.tableView.reloadData()
        
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var entry : Entry
        entry = model.displayedEntries[indexPath.row]
        
        let secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("EntryViewController") as! EntryViewController
        secondViewController.entryEditing = entry;
        
        self.navigationController!.pushViewController(secondViewController, animated: true)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        var entry : Entry
            entry = model.displayedEntries[indexPath.row]
        
        let dataLabel:UILabel = cell.viewWithTag(1) as! UILabel;
        let typeLabel:UILabel = cell.viewWithTag(2) as! UILabel;
        let descLabel:UILabel = cell.viewWithTag(3) as! UILabel;
        
        let dateFormatter = NSDateFormatter()//3
        
        var theDateFormat = NSDateFormatterStyle.ShortStyle //5
        let theTimeFormat = NSDateFormatterStyle.ShortStyle//6
        
        dateFormatter.dateStyle = theDateFormat//8
        dateFormatter.timeStyle = theTimeFormat//9
        
        dataLabel.text = dateFormatter.stringFromDate(entry.date);
        typeLabel.text = entry.entryType.rawValue;
        descLabel.text = entry.textDesc;
        
        if (entry.entryType == EntryType.meds)
        {
            cell.backgroundColor = UIColor(red: 218.0/255.0, green: 211.0/255.0, blue: 235.0/255.0, alpha: 1.0)
            
        }
        else if (entry.entryType == EntryType.food)
        {
            cell.backgroundColor = UIColor(red: 232.0/255.0, green: 235.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        }
        else
        {
            cell.backgroundColor = UIColor(red: 216.0/255.0, green: 232.0/255.0, blue: 226.0/255.0, alpha: 1.0)
        }
        
        return cell
    }
}

