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

    @IBAction func addUserId(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Add User", message: "Please enter a user ID.", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "UserID"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            if var id = alert.textFields?.first?.text, !id.isEmpty {
                if id.hasPrefix("user/") {
                    id = id.substring(from: "user/".endIndex)
                }
                
                self.userIds.append(id)
                let indexPath = IndexPath(row: self.userIds.count-1, section: 0)
                self.userIdTableView.insertRows(at: [indexPath], with: .automatic)
            }
        }))
        alert.preferredAction = alert.actions.last
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func createConversation(_ sneder: AnyObject!) {
        
        var userIds = self.userIds
        
        if !userIds.contains(SKYContainer.default().currentUserRecordID) {
            userIds.append(SKYContainer.default().currentUserRecordID)
        }
        
        // let ids be unique
        userIds = Array(Set(userIds))
        
        SKYContainer.default().chatExtension().createConversation(participantIDs: userIds, title: titleTextField.text, metadata: nil) { (conversation, error) in
            if let err = error {
                let alert = UIAlertController(title: "Unable to create group conversation", message: err.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }

            self.createdConversationTextView.text = conversation?.recordID.canonicalString
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userIds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = userIds[indexPath.row]
        return cell
    }

    // MARK: - Text view data source
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
