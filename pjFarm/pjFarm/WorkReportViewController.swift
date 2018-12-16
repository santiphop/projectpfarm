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
    var works = [String]()
    var detail = [String:[Int]]()
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func confirmButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let db = appDelegate.db
        works = db.workList
        detail = db.details
        print("inited")
        
    }
    

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
        return works.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workcell", for: indexPath)
        cell.textLabel?.text = works[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let db = appDelegate.db
        db.currentWork = works[indexPath.row]
        db.generateIDCountForTomorrowWork()
        print(db.currentWork)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! WorkDetailReportViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            controller.idSelect = self.detail[works[indexPath.row]]!
            controller.titleBar.title = self.works[indexPath.row]
        }
    }
    
    @IBAction func unwindToWorkTable(_ unwindSegue: UIStoryboardSegue) { }
    
}
