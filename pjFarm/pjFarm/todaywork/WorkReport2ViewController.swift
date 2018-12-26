//
//  WorkDetailReportViewController.swift
//  pjFarm
//
//  Created by Santiphop on 7/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class WorkReport2ViewController: UIViewController {
    var idSelect = [Int]()
    var detailSelect = [Bool]()

    @IBOutlet weak var titleBar: UINavigationItem!
    @IBAction func reportButton(_ sender: Any) {
        showOptionsAlert()
    }
    
    func report() {
        reportWorkForTomorrow(ids: idSelect, bools: detailSelect, date:Date())
        performSegue(withIdentifier: "detailToReportSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        detailSelect = [Bool](repeating: false, count: idSelect.count)
    }
    
    func showOptionsAlert() {
        let alertController = UIAlertController(title: "กรุณาตรวจสอบ ID หมู", message: "ID ของหมูที่เลือกทั้งหมด\nเป็นหมูตัวที่ยังทำงานไม่เสร็จ\nและจะเลื่อนงานไปทำต่อในวันพรุ่งนี้\nต้องการดำเนินการต่อหรือไม่", preferredStyle: UIAlertController.Style.alert)
        
        let actionNothing = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default)
        
        let actionReport = UIAlertAction(title: "Report", style: UIAlertAction.Style.destructive) { action in
            self.report()
        }
        
        alertController.addAction(actionNothing)
        alertController.addAction(actionReport)

        present(alertController, animated: true)
        
        
    }
    

}

extension WorkReport2ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return idSelect.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workdetailcell", for: indexPath)
        cell.textLabel?.text = "\(idSelect[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType != UITableViewCell.AccessoryType.checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
            detailSelect[indexPath.row] = true
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
            detailSelect[indexPath.row] = false
        }
    }
}
