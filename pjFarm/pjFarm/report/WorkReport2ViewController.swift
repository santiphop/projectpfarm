//
//  WorkDetailReportViewController.swift
//  pjFarm
//
//  Created by Santiphop on 7/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class WorkReport2ViewController: UIViewController {
    
    //  receive from WR1VC
    var selectedSection = [String]()
    var selectedRow = [[String]]()
    var selectedID = [[Int]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func reportButton(_ sender: Any) {
        showReportOptionsAlert()
    }
    
    func showReportOptionsAlert() {
        let alertController = UIAlertController(title: "กรุณาตรวจสอบ ID หมู", message: "ID ของหมูที่เลือกทั้งหมด\nเป็นหมูตัวที่ยังทำงานไม่เสร็จ\nและจะเลื่อนงานไปทำต่อในวันพรุ่งนี้\nต้องการดำเนินการต่อหรือไม่", preferredStyle: UIAlertController.Style.alert)
        
        let actionNothing = UIAlertAction(title: "ยกเลิก", style: UIAlertAction.Style.cancel)
        
        let actionReport = UIAlertAction(title: "เลื่อนไปทำพรุ่งนี้", style: UIAlertAction.Style.destructive) { action in
            self.report()
            self.performSegue(withIdentifier: "confirmToHome", sender: self)
            
        }
        
        alertController.addAction(actionReport)
        alertController.addAction(actionNothing)
        
        present(alertController, animated: true)
    }
    
    func report() {
        for i in 0...selectedSection.count-1 {
            self.reportWorkForTomorrow(currentWork: selectedSection[i], ids: selectedID[i])
        }
    }

    func reportWorkForTomorrow(currentWork:String, ids:[Int]) {
        let date = Date()
        let todayPath = "งาน/\(dateFormat.string(from: date))W/\(currentWork)"
        
        ref.child("\(todayPath)").observeSingleEvent(of: .value, with: { (snapshot) in
            let data = snapshot.value as! NSDictionary
            let pigtype = data["pigtype"] as! String
            let workstep = data["workstep"] as! Int
            let wName = workData.getAt(type: pigtype).name
            
            for i in 0...ids.count-1 {
                //  setValue 2 = UNDONE
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
            
            /*
            //  NO Need to removeIndex() anymore
            //  RE-getWork every Report Button Touch-Up
            
            //  .reversed
            //  prevent remove index out of range
            for i in indexToRemove.reversed() {
                workInfo[currentWork]?.remove(at: i)
            }
            if (workInfo[currentWork]?.isEmpty)! {
                workInfo.removeValue(forKey: currentWork)
                workList.remove(at: atIndex)
            }
            */
            
        })
    }
}

extension WorkReport2ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedRow[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return selectedSection[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "confirmcell", for: indexPath)
        cell.textLabel?.text = selectedRow[indexPath.section][indexPath.row]
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 25)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return selectedRow.count
    }
}
