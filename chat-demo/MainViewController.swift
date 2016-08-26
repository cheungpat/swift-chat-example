//
//  ViewController.swift
//  chat-demo
//
//  Created by Joey on 8/25/16.
//  Copyright © 2016 Oursky Ltd. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    var hasPromptedForConfiguration: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey("HasPromptedForConfiguration")
        }
        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: "HasPromptedForConfiguration")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !self.hasPromptedForConfiguration {
            let alert = UIAlertController(title: "Configuration Required",
                                          message: "The app does not know how to connect to your Skygear Server. Configure the app now?",
                                          preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ignore", style: .Cancel, handler: { (action) in
                self.hasPromptedForConfiguration = true
            }))
            alert.addAction(UIAlertAction(title: "Configure", style: .Default, handler: { (action) in
                self.hasPromptedForConfiguration = true
                self.performSegueWithIdentifier("server_configuration", sender: self)
            }))
            alert.preferredAction = alert.actions.last
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
    
}

