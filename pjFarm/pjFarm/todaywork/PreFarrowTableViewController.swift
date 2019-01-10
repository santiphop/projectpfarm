//
//  PreFarrowTableViewController.swift
//  pjFarm
//
//  Created by Santiphop on 9/1/2562 BE.
//  Copyright © 2562 iOS Dev. All rights reserved.
//

import UIKit

class PreFarrowTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (pigs["แม่พันธุ์"]?.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "preFarrow", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = pigs["แม่พันธุ์"]![indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? Farrow1ViewController,
            let indexPath = tableView.indexPathForSelectedRow{
            controller.momString = pigs["แม่พันธุ์"]![indexPath.row]
        }
    }
}
