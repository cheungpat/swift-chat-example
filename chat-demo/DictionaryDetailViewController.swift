//
//  DictionaryDetailViewController.swift
//  chat-demo
//
//  Created by Joey on 9/1/16.
//  Copyright © 2016 Oursky Ltd. All rights reserved.
//

import UIKit

class DictionaryDetailViewController: UITableViewController {
    
    var dictionary = NSDictionary()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dictionary.allKeys.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        cell.textLabel?.text = "\(dictionary.allKeys[indexPath.row])"
        cell.detailTextLabel?.text = "\(dictionary.allValues[indexPath.row])"

        return cell
    }

}
