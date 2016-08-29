//
//  CreateGroupConversationViewController.swift
//  chat-demo
//
//  Created by Joey on 8/29/16.
//  Copyright © 2016 Oursky Ltd. All rights reserved.
//

import UIKit
import SKYKit

class CreateGroupConversationViewController: UIViewController {

    @IBOutlet var userIdTableView: UITableView!
    @IBOutlet var createdConversationTextView: UITextView!
    
    
    
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
            let userId = alert.textFields?.first?.text
            
            if (userId ?? "").isEmpty {
                return
            }
            
            //do something
        }))
        alert.preferredAction = alert.actions.last
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func createConversation(sneder: AnyObject!) {
        
        SKYContainer.defaultContainer().createConversationWithParticipantIds(<#T##participantIds: [AnyObject]!##[AnyObject]!#>, withAdminIds: <#T##[AnyObject]!#>, withTitle: <#T##String!#>, completionHandler: <#T##SKYContainerConversationOperationActionCompletion!##SKYContainerConversationOperationActionCompletion!##(SKYConversation!, NSError!) -> Void#>)
    }

}
