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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func confirmReport(_ sender: Any) {
        showOptionsAlert()
    }
    func showOptionsAlert() {
        let alertController = UIAlertController(title: "กรุณาตรวจสอบงาน", message: "งานที่ไม่ได้ Report ทั้งหมด\nจะเปลี่ยนสถานะเป็น DONE\nต้องการดำเนินการต่อหรือไม่", preferredStyle: UIAlertController.Style.alert)
        
        let actionNothing = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default)
        
        let actionReport = UIAlertAction(title: "Mark As Done     ", style: UIAlertAction.Style.destructive) { action in
            markAsDone(date: Date())
            self.performSegue(withIdentifier: "reportToHome", sender: self)
        }
        
        alertController.addAction(actionReport)
        alertController.addAction(actionNothing)

        present(alertController, animated: true)
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? WorkReport2ViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            controller.idSelect = workInfo[workList[indexPath.row]]!
            controller.titleBar.title = workList[indexPath.row]
            print(workInfo)
        }
    }
    
    @IBAction func unwindToWorkTable(_ unwindSegue: UIStoryboardSegue) { }

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
        print("chosen: \(currentWork)")
    }

    
}
