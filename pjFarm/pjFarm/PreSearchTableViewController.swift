//
//  PreSearchTableViewController.swift
//  pjFarm
//
//  Created by Santiphop on 10/1/2562 BE.
//  Copyright © 2562 iOS Dev. All rights reserved.
//

import UIKit

class PreSearchTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (pigs["ทั้งหมด"]?.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "preSearch", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = pigs["ทั้งหมด"]![indexPath.row]

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? SearchResultViewController,
            let indexPath = tableView.indexPathForSelectedRow{
            controller.id = pigs["ทั้งหมด"]![indexPath.row]
        }
    }
}
