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


    @IBAction func sendBtnPressed(sender: AnyObject) {
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        var emailBody:String = ""
        
        for entry in Model.sharedInstance.displayedEntries {
            let dateFormatter = NSDateFormatter()//3
            var theDateFormat = NSDateFormatterStyle.ShortStyle //5
            let theTimeFormat = NSDateFormatterStyle.ShortStyle//6
            
            dateFormatter.dateStyle = theDateFormat//8
            dateFormatter.timeStyle = theTimeFormat//9
            
            
            emailBody += dateFormatter.stringFromDate(entry.date) + " - " + entry.entryType.rawValue +  " - " + entry.textDesc + "\r\n"
            
        }
        
        
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([emailAddresstxt.text])
        mailComposerVC.setSubject("Food/Drug/Symptom logs")
        mailComposerVC.setMessageBody(emailBody, isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
}

