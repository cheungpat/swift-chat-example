//
//  ConversationsViewController.swift
//  chat-demo
//
//  Created by Joey on 9/1/16.
//  Copyright © 2016 Oursky Ltd. All rights reserved.
//

import UIKit
import SKYKit

class ConversationsViewController: UITableViewController {
    
    var userCons = [SKYUserConversation]()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        SKYContainer.defaultContainer().getUserConversationsCompletionHandler { (userCons, error) in
            if error != nil {
                let alert = UIAlertController(title: "Unable to fetch conversations", message: error.localizedDescription, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            
            // newest should be on top
            self.userCons = userCons.reverse()
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "conversation_room" {
            let controller = segue.destinationViewController as! ConversationRoomViewController
            controller.userCon = sender as! SKYUserConversation
        }
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userCons.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        let conversation = userCons[indexPath.row].conversation
        cell.textLabel?.text = "\(conversation.title)"
        cell.detailTextLabel?.text = "\(conversation.recordID.canonicalString)"

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("conversation_room", sender: userCons[indexPath.row])
    }

}
