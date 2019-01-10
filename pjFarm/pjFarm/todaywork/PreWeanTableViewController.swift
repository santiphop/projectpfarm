//
//  PreWeanTableViewController.swift
//  pjFarm
//
//  Created by Santiphop on 9/1/2562 BE.
//  Copyright © 2562 iOS Dev. All rights reserved.
//

import UIKit

class PreWeanTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (pigs["คอกคลอด"]?.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "preWaen", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = pigs["คอกคลอด"]![indexPath.row]

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? WeanViewController,
            let indexPath = tableView.indexPathForSelectedRow{
            controller.momId = pigs["คอกคลอด"]![indexPath.row]
        }
    }
 

}
