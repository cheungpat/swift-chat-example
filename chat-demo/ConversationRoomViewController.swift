//
//  ConversationRoomViewController.swift
//  chat-demo
//
//  Created by Joey on 9/1/16.
//  Copyright © 2016 Oursky Ltd. All rights reserved.
//

import UIKit
import SKYKit

class ConversationRoomViewController:
    UIViewController,
    UITableViewDelegate,
    UITableViewDataSource,
    UITextFieldDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var bottomEdgeConstraint: NSLayoutConstraint!
    @IBOutlet var messaegBodyTextField: UITextField!
    @IBOutlet var messageMetadataTextField: UITextField!
    
    var userCon: SKYUserConversation!
    var messages = [SKYMessage]()
    var lastReadMessage:SKYMessage?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = userCon.conversation.title
        self.lastReadMessage = userCon.lastReadMessage
        
        // listening keyboard event
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillChangeFrameNotification, object: nil, queue: nil) { (note) in
            let keyboardFrame: CGRect = (note.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            let animationDuration: NSTimeInterval = (note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
            let animationCurve: UIViewAnimationCurve = UIViewAnimationCurve(rawValue: (note.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue)!
            UIView.animateWithDuration(animationDuration, animations: {
                UIView.setAnimationCurve(animationCurve)
                self.bottomEdgeConstraint.constant = keyboardFrame.height
                self.view.layoutIfNeeded()
            })
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillHideNotification, object: nil, queue: nil) { (note) in
            let animationDuration: NSTimeInterval = (note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
            
            UIView.animateWithDuration(animationDuration, animations: {
                self.bottomEdgeConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
            
        }
        
        // subscribe chat messages
        // FIXME: SDK should help deserialize SKYMessage?
        SKYContainer.defaultContainer().subscribeHandler({ (dictionary) in
            if let recordType = dictionary["record_type"] as? String where recordType == "message",
                let recordDic = dictionary["record"] as? [NSObject : AnyObject],
                let record = SKYRecordDeserializer().recordWithDictionary(recordDic),
                let message = SKYMessage(record: record) where message.conversationID == self.userCon.conversation.recordID.recordName {
                
                self.messages.insert(message, atIndex: 0)
                let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        })
        
        // get conversation messages
        SKYContainer.defaultContainer().getMessagesWithConversationId(userCon.conversation.recordID.recordName, withLimit: "100", withBeforeTime: NSDate()) { (messages, error) in
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
        performSegueWithIdentifier("conversation_detail", sender: userCon)
    }

    @IBAction func sendMessage(sender: AnyObject) {
        // chat SDK createMessage method still not fully implement
        SKYContainer.defaultContainer().createMessageWithConversationId(
            self.userCon.conversation.recordID.recordName,
            withBody: messaegBodyTextField.text,
            withURL: nil,
            withType: SKYChatMetaDataType.Text,
            withDuration:0) { (message, error) in
                
                if error != nil {
                    let alert = UIAlertController(title: "Unable to send message", message: error.localizedDescription, preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    return
                }
                
                if message != nil {
                    print("send message successful")
                }
        }
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
        let message = messages[indexPath.row]
        
        var lastRead = ""
        if lastReadMessage != nil && lastReadMessage?.recordID.recordName == message.recordID.recordName {
            lastRead = "  === last read message ==="
        }
        cell.textLabel?.text = message.body + lastRead
        cell.detailTextLabel?.text = message.recordID.canonicalString

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("message_detail", sender: messages[indexPath.row].dictionary)
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let unreadAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal , title: "mark as unread") { (action, indexPath) in
            
            let message = self.messages[indexPath.row]
            SKYContainer.defaultContainer().markAsLastMessageReadWithConversationId(
                self.userCon.conversation.recordID.recordName,
                withMessageId: message.recordID.recordName,
                completionHandler: { (userCon, error) in
                    
                    if error != nil {
                        let alert = UIAlertController(title: "Unable to mark last read message", message: error.localizedDescription, preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                        return
                    }
                    
                    self.refreshConversation()
            })
        }
        
        return [unreadAction]
    }
    
    // MARK: - Text field delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "message_detail" {
            let controller = segue.destinationViewController as! DictionaryDetailViewController
            controller.dictionary = sender as! NSDictionary
        } else if segue.identifier == "conversation_detail" {
            let controller = segue.destinationViewController as! ConversationDetailViewController
            controller.userCon = sender as! SKYUserConversation
        }
    }
    
    func refreshConversation() {
        SKYContainer.defaultContainer().getConversationWithConversationId(self.userCon.conversation.recordID.recordName,
                                                                          completionHandler: { (conversation, error) in
                                                                            self.userCon = conversation
                                                                            self.lastReadMessage = conversation.lastReadMessage
                                                                            self.tableView.reloadData()
        })
    }
}
