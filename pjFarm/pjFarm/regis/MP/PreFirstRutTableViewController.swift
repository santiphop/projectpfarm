//
//  FirstRutTableViewController.swift
//  pjFarm
//
//  Created by Santiphop on 9/1/2562 BE.
//  Copyright © 2562 iOS Dev. All rights reserved.
//

import UIKit

class PreFirstRutTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pigs["หมูสาว"]!.count

    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "preMaepun", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = pigs["หมูสาว"]![indexPath.row]
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 25)
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? FirstRutViewController,
            let indexpath = tableView.indexPathForSelectedRow{
            controller.pigId = pigs["หมูสาว"]![indexpath.row]
        }
    }

}
