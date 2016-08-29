//
//  UsersViewController.swift
//  chat-demo
//
//  Created by Joey on 8/26/16.
//  Copyright © 2016 Oursky Ltd. All rights reserved.
//

import UIKit
import SKYKit

class UsersViewController: UITableViewController {
    
    var users = [SKYRecord]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = SKYQuery(recordType: "user", predicate: nil)
        SKYContainer.defaultContainer().publicCloudDatabase.performQuery(query) { (result, error) in
            if (error != nil) {
                let alert = UIAlertController(title: "Unable to get users", message: error.localizedDescription, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            
            if let users = result as? [SKYRecord] {
                self.users = users
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detail" {
            let controller = segue.destinationViewController as! DetailViewController
            let user = users[(self.tableView.indexPathForSelectedRow?.row)!]
            controller.detailText = user.recordID.canonicalString
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.recordID.canonicalString
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("detail", sender: nil)
    }
}
