//
//  PreRegisterTableViewController.swift
//  pjFarm
//
//  Created by Santiphop on 9/1/2562 BE.
//  Copyright © 2562 iOS Dev. All rights reserved.
//

import UIKit

class PreRegisterTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pigs["คอกอนุบาล"]!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "preregis", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = pigs["คอกอนุบาล"]![indexPath.row]
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 25)
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        return cell
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? RegisterViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            controller.momID = pigs["คอกอนุบาล"]![indexPath.row]
        }
    }
}
