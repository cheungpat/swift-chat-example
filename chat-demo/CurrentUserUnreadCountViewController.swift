//
//  CurrentUserUnreadCountViewController.swift
//  chat-demo
//
//  Created by Joey on 8/26/16.
//  Copyright © 2016 Oursky Ltd. All rights reserved.
//

import UIKit
import SKYKit

class CurrentUserUnreadCountViewController: UITableViewController {
    
    let unreadConversationCountRowIndex = 0
    let unreadMessageCountRowIndex = 1
    
    var unreadConversationCount:Int?
    var unreadMessageCount:Int?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SDK should implement get total unread
//        SKYContainer.defaultContainer().getUnreadMessageCount { (response, error) in
//            if (error != nil) {
//                let alert = UIAlertController(title: "Unable to get unread count", message: error.localizedDescription, preferredStyle: .Alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//                self.presentViewController(alert, animated: true, completion: nil)
//                return
//            }
//            
//            self.unreadConversationCount = response["conversation"] as? Int
//            self.unreadMessageCount = response["message"] as? Int
//            
//            self.tableView.reloadData()
//        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("plain", forIndexPath: indexPath)
        switch indexPath.row {
        case self.unreadConversationCountRowIndex:
            cell.textLabel?.text = "Conversation"
            if let count = self.unreadConversationCount {
                cell.detailTextLabel?.text = String(count)
            }
            return cell
        case self.unreadMessageCountRowIndex:
            cell.textLabel?.text = "Message"
            if let count = self.unreadMessageCount {
                cell.detailTextLabel?.text = String(count)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
}