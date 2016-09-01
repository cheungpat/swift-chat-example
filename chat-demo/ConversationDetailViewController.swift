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
    
    // FIXME: SDK should be able get conversation unread count
    let participantIdsSection = 0
    let adminIdsSection = 1
    
    var conversation: SKYConversation!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Action
    @IBAction func addParticipant(sender: AnyObject) {
        // FIXME: call this method will crash, SDK should fix getConversationWithConversationId
//        if let id = participantTextField.text where !id.isEmpty {
//            SKYContainer.defaultContainer().addParticipantsWithConversationId(
//                conversation.recordID.recordName,
//                withParticipantIds: [id],
//                completionHandler: { (conversation, error) in
//                    
//                    if error != nil {
//                        let alert = UIAlertController(title: "Unable to add user to participant.", message: error.localizedDescription, preferredStyle: .Alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//                        self.presentViewController(alert, animated: true, completion: nil)
//                        return
//                    }
//                    
//                    self.conversation = conversation
//                    self.tableView.reloadData()
//            })
//        }
    }

    @IBAction func removeParticipant(sender: AnyObject) {
        // FIXME: call this method will crash, SDK should fix getConversationWithConversationId
//        if let id = participantTextField.text where !id.isEmpty {
//            print("\(conversation.recordID.recordName)")
//            SKYContainer.defaultContainer().removeParticipantsWithConversationId(
//                conversation.recordID.recordName,
//                withParticipantIds: [id],
//                completionHandler: { (conversation, error) in
//                    
//                    if error != nil {
//                        let alert = UIAlertController(title: "Unable to remove user from participant.", message: error.localizedDescription, preferredStyle: .Alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//                        self.presentViewController(alert, animated: true, completion: nil)
//                        return
//                    }
//                    
//                    self.conversation = conversation
//                    self.tableView.reloadData()
//            })
//        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case participantIdsSection:
            return conversation.participantIds.count
        case adminIdsSection:
            return conversation.adminIds.count
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case participantIdsSection:
            return "ParticipantIds"
        case adminIdsSection:
            return "adminIds"
        default:
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case participantIdsSection:
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            cell.textLabel?.text = conversation.participantIds[indexPath.row]
            return cell
        case adminIdsSection:
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            cell.textLabel?.text = conversation.adminIds[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case participantIdsSection:
            performSegueWithIdentifier("showDetail", sender: conversation.participantIds[indexPath.row])
        case adminIdsSection:
            performSegueWithIdentifier("showDetail", sender: conversation.adminIds[indexPath.row])
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
