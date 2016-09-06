//
//  ConversationDetailViewController.swift
//  chat-demo
//
//  Created by Joey on 9/1/16.
//  Copyright © 2016 Oursky Ltd. All rights reserved.
//

import UIKit
import SKYKit

class ConversationDetailViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet var participantTextField: UITextField!
    
    let unreadMessageCount = 0
    let participantIdsSection = 1
    let adminIdsSection = 2
    
    var userCon: SKYUserConversation!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshConversation()
    }
    
    // MARK: - Action
    @IBAction func addParticipant(sender: AnyObject) {
        if let id = participantTextField.text where !id.isEmpty {
            SKYContainer.defaultContainer().addParticipantsWithConversationId(
                userCon.conversation.recordID.recordName,
                withParticipantIds: [id],
                completionHandler: { (conversation, error) in
                    
                    if error != nil {
                        let alert = UIAlertController(title: "Unable to add user to participant.", message: error.localizedDescription, preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                        return
                    }
                    
                    self.refreshConversation()
            })
        }
    }

    @IBAction func removeParticipant(sender: AnyObject) {
        if let id = participantTextField.text where !id.isEmpty {
            SKYContainer.defaultContainer().removeParticipantsWithConversationId(
                userCon.conversation.recordID.recordName,
                withParticipantIds: [id],
                completionHandler: { (conversation, error) in
                    
                    if error != nil {
                        let alert = UIAlertController(title: "Unable to remove user from participant.", message: error.localizedDescription, preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                        return
                    }
                    
                    self.refreshConversation()
            })
        }
    }
    
    func refreshConversation() {
        SKYContainer.defaultContainer().getUserConversationWithConversationId(self.userCon.conversation.recordID.recordName,
                                                                          completionHandler: { (conversation, error) in
                                                                            self.userCon = conversation
                                                                            self.tableView.reloadData()
        })
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case unreadMessageCount:
            return 1
        case participantIdsSection:
            return userCon.conversation.participantIds.count
        case adminIdsSection:
            return userCon.conversation.adminIds.count
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case unreadMessageCount:
            return "Unread Count"
        case participantIdsSection:
            return "ParticipantIds"
        case adminIdsSection:
            return "AdminIds"
        default:
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case unreadMessageCount:
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            cell.textLabel?.text = "\(userCon.unreadCount)"
            return cell
        case participantIdsSection:
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            cell.textLabel?.text = userCon.conversation.participantIds[indexPath.row]
            return cell
        case adminIdsSection:
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            cell.textLabel?.text = userCon.conversation.adminIds[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case participantIdsSection:
            performSegueWithIdentifier("showDetail", sender: userCon.conversation.participantIds[indexPath.row])
        case adminIdsSection:
            performSegueWithIdentifier("showDetail", sender: userCon.conversation.adminIds[indexPath.row])
        default: break
        }
    }
    
    // MARK: - Text Field delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let controller = segue.destinationViewController as! DetailViewController
            controller.detailText = sender as! String
        }
    }
}
