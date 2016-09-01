//
//  CreateGroupConversationViewController.swift
//  chat-demo
//
//  Created by Joey on 8/29/16.
//  Copyright © 2016 Oursky Ltd. All rights reserved.
//

import UIKit
import SKYKit

class CreateGroupConversationViewController:
    UIViewController,
    UITableViewDelegate,
    UITableViewDataSource,
    UITextFieldDelegate {

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var userIdTableView: UITableView!
    @IBOutlet var createdConversationTextView: UITextView!
    
    var userIds = [String]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions

    @IBAction func addUserId(sender: AnyObject) {
        let alert = UIAlertController(title: "Add User", message: "Please enter a user ID.", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "UserID"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .Default, handler: { (action) in
            if var id = alert.textFields?.first?.text where !id.isEmpty {
                if id.hasPrefix("user/") {
                    id = id.substringFromIndex("user/".endIndex)
                }
                
                self.userIds.append(id)
                let indexPath = NSIndexPath(forRow: self.userIds.count-1, inSection: 0)
                self.userIdTableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        }))
        alert.preferredAction = alert.actions.last
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func createConversation(sneder: AnyObject!) {
        
        var userIds = self.userIds
        
        if !userIds.contains(SKYContainer.defaultContainer().currentUserRecordID) {
            userIds.append(SKYContainer.defaultContainer().currentUserRecordID)
        }
        
        // let ids be unique
        userIds = Array(Set(userIds))
        
        SKYContainer.defaultContainer().createConversationWithParticipantIds(userIds, withAdminIds: userIds, withTitle: titleTextField.text) { (conversation, error) in
            if error != nil {
                let alert = UIAlertController(title: "Unable to create group conversation", message: error.localizedDescription, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            
            self.createdConversationTextView.text = conversation.recordID.canonicalString
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userIds.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = userIds[indexPath.row]
        return cell
    }

    // MARK: - Text view data source
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
