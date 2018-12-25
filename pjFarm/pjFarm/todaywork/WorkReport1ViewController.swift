//
//  WorkReportViewController.swift
//  pjFarm
//
//  Created by Santiphop on 7/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class WorkReport1ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var isBackToHome:Bool = false
    var selectedWork = String()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if !isBackToHome {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = segue.destination as! WorkReport2ViewController
                controller.idSelect = workInfo[workList[indexPath.row]]!
                controller.titleBar.title = workList[indexPath.row]
                print(workInfo)
            }
        }
    }
    
    @IBAction func unwindToWorkTable(_ unwindSegue: UIStoryboardSegue) { }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WorkReport1ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workcell", for: indexPath)
        cell.textLabel?.text = workList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentWork = workList[indexPath.row]
        print(currentWork)
    }

    
}
