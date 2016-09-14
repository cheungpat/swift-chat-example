//
//  CreateDirectConversation.swift
//  chat-demo
//
//  Created by Joey on 8/26/16.
//  Copyright © 2016 Oursky Ltd. All rights reserved.
//

import UIKit
import SKYKit

class CreateDirectConversationViewController: UIViewController {
    
    @IBOutlet var userIdTextField: UITextField!
    @IBOutlet var createdConversationTextView: UITextView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // MARK: - Actions
    
    @IBAction func createConversation(sneder: AnyObject!) {
        if var id = userIdTextField.text where !id.isEmpty {
            
            if id.hasPrefix("user/") {
                id = id.substringFromIndex("user/".endIndex)
            }
            
            SKYContainer.defaultContainer().getOrCreateDirectConversationWithuUserId(id, completionHandler: { (conversation, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Unable to create direct conversation", message: error.localizedDescription, preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    return
                }
                
                self.createdConversationTextView.text = conversation.recordID.canonicalString
            })
        }
    }
}