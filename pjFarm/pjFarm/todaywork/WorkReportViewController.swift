//
//  WorkReportViewController.swift
//  pjFarm
//
//  Created by Santiphop on 7/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class WorkReportViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var currentWorkList = [String]()
    var currentWorkInfo = [String:[Int]]()
    var isBackToHome:Bool = false
    var selectedWork = String()
    
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func confirmButton(_ sender: Any) {
        isBackToHome = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let db = appDelegate.db
        currentWorkList = db.workList
        currentWorkInfo = db.workInfo        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if !isBackToHome {
            let db = appDelegate.db
            currentWorkInfo = db.workInfo
            let controller = segue.destination as! WorkDetailReportViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                controller.workName = self.selectedWork
                controller.idSelect = self.currentWorkInfo[currentWorkList[indexPath.row]]!
                controller.titleBar.title = self.currentWorkList[indexPath.row]
                print(currentWorkInfo)
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

extension WorkReportViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentWorkList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workcell", for: indexPath)
        cell.textLabel?.text = currentWorkList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let db = appDelegate.db
        db.currentWork = currentWorkList[indexPath.row]
        selectedWork = currentWorkList[indexPath.row]
//        db.generateIDCountForTomorrowWork()
        print(db.currentWork)
    }

    
}
