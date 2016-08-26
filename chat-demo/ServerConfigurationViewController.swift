//
//  ServerConfigurationViewController.swift
//  chat-demo
//
//  Created by Joey on 8/26/16.
//  Copyright © 2016 Oursky Ltd. All rights reserved.
//

import UIKit
import SKYKit

class ServerConfigurationViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("plainTableViewCell", forIndexPath: indexPath)
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Endpoint"
            cell.detailTextLabel?.text = NSUserDefaults.standardUserDefaults().stringForKey("SkygearEndpoint")
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "API Key"
            cell.detailTextLabel?.text = NSUserDefaults.standardUserDefaults().stringForKey("SkygearApiKey")
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            let alert = UIAlertController(title: "Endpoint", message: "Enter the Skygear Endpoint (you can obtained this from portal)", preferredStyle: .Alert)
            alert.addTextFieldWithConfigurationHandler { (textField) in
                textField.placeholder = "https://myapp.skygeario.com/"
                textField.text = NSUserDefaults.standardUserDefaults().stringForKey("SkygearEndpoint")
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler:nil))
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
                let textField = alert.textFields?.first
                NSUserDefaults.standardUserDefaults().setObject(textField?.text, forKey: "SkygearEndpoint")
                NSUserDefaults.standardUserDefaults().synchronize()
                SKYContainer.defaultContainer().configAddress(textField?.text)
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }))
            alert.preferredAction = alert.actions.last
            self.presentViewController(alert, animated: true, completion: nil)
        } else if indexPath.row == 1 {
            let alert = UIAlertController(title: "API Key", message: "Enter the Skygear API Key (you can obtained this from portal)", preferredStyle: .Alert)
            alert.addTextFieldWithConfigurationHandler { (textField) in
                textField.placeholder = "dc0903fa85924776baa77df813901efc"
                textField.text = NSUserDefaults.standardUserDefaults().stringForKey("SkygearApiKey")
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler:nil))
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
                let textField = alert.textFields?.first
                NSUserDefaults.standardUserDefaults().setObject(textField?.text, forKey: "SkygearApiKey")
                NSUserDefaults.standardUserDefaults().synchronize()
                SKYContainer.defaultContainer().configureWithAPIKey(textField?.text)
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }))
            alert.preferredAction = alert.actions.last
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}

