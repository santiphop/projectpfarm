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
            self.markAsDone()
            self.performSegue(withIdentifier: "reportToHome", sender: self)
        }
        
        alertController.addAction(actionReport)
        alertController.addAction(actionNothing)

        present(alertController, animated: true)
    }
    
    func markAsDone() {
        //  today only
        let todayWorkPath = "งาน/\(dateFormat.string(from: Date()))W"
        ref.child(todayWorkPath).observeSingleEvent(of: .value) { (snapshot) in
            if let data = snapshot.value as? NSDictionary {
                for (work, ids) in data {
                    for (id, status) in ids as! NSDictionary {
                        //  mark only code 0 : ASSIGNED
                        if let intID = Int(id as! String), (status as! Int) == 0 {
                            //  mark as done
                            //  code 1 : DONE
                            ref.child("\(todayWorkPath)/\(work as! String)/\(intID)").setValue(1)
                        }
                    }
                }
            }
            //  clear the work
            //  prevent reporting today again
            workList.removeAll()
            workInfo.removeAll()
        }
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
