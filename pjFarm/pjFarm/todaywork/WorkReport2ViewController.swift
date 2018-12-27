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
    
    func reportWorkForTomorrow(ids:[Int], bools:[Bool], date:Date) {
        let todayPath = "งาน/\(dateFormat.string(from: date))W/\(currentWork)"
        
        ref.child("\(todayPath)").observeSingleEvent(of: .value, with: { (snapshot) in
            let data = snapshot.value as! NSDictionary
            
            let pigtype = data["pigtype"] as! String
            let workstep = data["workstep"] as! Int
            let wName = workData.getAt(type: pigtype).name
            
            for i in 0...ids.count-1 {
                if bools[i] {
                    //  setValue 2 is UNDONE
                    ref.child("\(todayPath)/\(ids[i])").setValue(2)
                    
                    
                    let wDateRemain = workData.getAt(type: pigtype).generateWorkDate(date: date, fromIndex: workstep + 1)
                    let wDate2morrow = tomorrow(date: wDateRemain)
                    
                    
                    for j in 0...wDateRemain.count-1 {
                        //  remove and reassign remain
                        
                        ref.child("งาน/\(dateFormat.string(from: wDateRemain[j]))W/\(wName[workstep+j+1])/\(ids[i])").removeValue()
                        
                        ref.child("งาน/\(dateFormat.string(from: wDate2morrow[j]))W/\(wName[workstep+j+1])/\(ids[i])").setValue(0)
                        ref.child("งาน/\(dateFormat.string(from: wDate2morrow[j]))W/\(wName[workstep+j+1])/pigtype").setValue(pigtype)
                        ref.child("งาน/\(dateFormat.string(from: wDate2morrow[j]))W/\(wName[workstep+j+1])/workstep").setValue(workstep+j+1)
                    }
                    
                    //  assign tomorrow
                    ref.child("งาน/\(dateFormat.string(from: tomorrow(date: date)))W/\(currentWork)/\(ids[i])").setValue(0)
                    ref.child("งาน/\(dateFormat.string(from: tomorrow(date: date)))W/\(currentWork)/pigtype").setValue(pigtype)
                    ref.child("งาน/\(dateFormat.string(from: tomorrow(date: date)))W/\(currentWork)/workstep").setValue(workstep)
                    
                }
            }
            getAllWorkFrom(date: Date())
        })
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
