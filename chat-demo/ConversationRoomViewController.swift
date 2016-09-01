//
//  ConversationRoomViewController.swift
//  chat-demo
//
//  Created by Joey on 9/1/16.
//  Copyright © 2016 Oursky Ltd. All rights reserved.
//

import UIKit
import SKYKit

class ConversationRoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var conversation: SKYConversation!
    
    var messages = [SKYMessage]()

    @IBOutlet var tableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = conversation.title
        
        // FIXME: SDK should help deserialize SKYMessage?
        SKYContainer.defaultContainer().subscribeHandler({ (dictionary) in
            if let recordType = dictionary["record_type"] as? String where recordType == "message",
                let recordDic = dictionary["record"] as? [NSObject : AnyObject],
                let record = SKYRecordDeserializer().recordWithDictionary(recordDic),
                let message = SKYMessage(record: record) where message.conversationID == self.conversation.recordID.recordName {
                
                self.messages.insert(message, atIndex: 0)
                let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        })
        
        SKYContainer.defaultContainer().getMessagesWithConversationId(conversation.recordID.recordName, withLimit: "100", withBeforeTime: NSDate()) { (messages, error) in
            if error != nil {
                let alert = UIAlertController(title: "Unable to fetch conversations", message: error.localizedDescription, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            
            if messages != nil {
                // newest should be on top
                self.messages = messages.reverse()
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Action
    
    @IBAction func showDetail(sender: AnyObject) {
        performSegueWithIdentifier("conversation_detail", sender: conversation)
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        cell.textLabel?.text = messages[indexPath.row].body
        cell.detailTextLabel?.text = messages[indexPath.row].recordID.canonicalString

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("message_detail", sender: messages[indexPath.row].dictionary)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "message_detail" {
            let controller = segue.destinationViewController as! DictionaryDetailViewController
            controller.dictionary = sender as! NSDictionary
        } else if segue.identifier == "conversation_detail" {
            let controller = segue.destinationViewController as! ConversationDetailViewController
            controller.conversation = sender as! SKYConversation
        }
    }
}
