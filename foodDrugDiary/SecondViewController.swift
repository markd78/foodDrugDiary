//
//  SecondViewController.swift
//  foodDrugDiary
//
//  Created by Mark Davies on 6/18/15.
//  Copyright (c) 2015 Comantis LLC. All rights reserved.
//

import UIKit
import MessageUI

class SecondViewController: UIViewController,MFMailComposeViewControllerDelegate {

    @IBOutlet weak var emailAddresstxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    @IBAction func sendCVSFilePressed(sender: AnyObject) {
        
        let mailComposeViewController = configuredMailComposeViewController(true)
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }

    @IBAction func sendBtnPressed(sender: AnyObject) {
        
        let mailComposeViewController = configuredMailComposeViewController(false)
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController(withCSV:Bool) -> MFMailComposeViewController {
        
        var emailBody:String = ""
        var csvString = NSMutableString()
        
        if (withCSV)
        {
            
            csvString.appendString("Date,Time,Type,Description")

        }
        
        for entry in Model.sharedInstance.displayedEntries {
            let dateFormatter = NSDateFormatter()//3
            var theDateFormat = NSDateFormatterStyle.ShortStyle //5
            let theTimeFormat = NSDateFormatterStyle.ShortStyle//6
            
            dateFormatter.dateStyle = theDateFormat//8
            dateFormatter.timeStyle = theTimeFormat//9
            
            if (withCSV)
            {
                var tempDate = dateFormatter.stringFromDate(entry.date)
                dateFormatter.dateFormat = "HH:mm:ss"
                var tempTime = dateFormatter.stringFromDate(entry.date)
                
               
                
                csvString.appendString("\n\(tempDate),\(entry.entryType.rawValue),\"\(entry.textDesc)\"")
                
            }
            
            emailBody += dateFormatter.stringFromDate(entry.date) + " - " + entry.entryType.rawValue +  " - " + entry.textDesc + "\r\n"
            
        }
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate--property
        
        if (withCSV)
        {
            let fileManager = (NSFileManager.defaultManager())
            let directorys : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
            
            if ((directorys) != nil) {
                
                let directories:[String] = directorys!;
                let dictionary = directories[0];
                let plistfile = "fodoDiaryLogs.csv"
                let plistpath = dictionary.stringByAppendingPathComponent(plistfile);
                
                println("\(plistpath)")
                
                csvString.writeToFile(plistpath, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
                
                var testData: NSData = NSData(contentsOfFile: plistpath)!
                mailComposerVC.addAttachmentData(testData, mimeType: "text/csv", fileName: "fodoDiaryLogs.csv")
            }
            
           

        }
        
            
        mailComposerVC.setToRecipients([emailAddresstxt.text])
        mailComposerVC.setSubject("Food/Drug/Symptom logs")
        mailComposerVC.setMessageBody(emailBody, isHTML: false)
        
        return mailComposerVC
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
}

