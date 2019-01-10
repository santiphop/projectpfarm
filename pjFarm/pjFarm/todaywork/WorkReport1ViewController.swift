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
    
    var intIDs = [[Int]]()
    var stringIDs = [[String]]()
    var boolIDs = [[Bool]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        for name in workList {
            let intArray = workInfo[name]!
            var strArray = [String]()
            for i in intArray {
                strArray.append(String(i))
            }
            intIDs.append(intArray)
            stringIDs.append(strArray)
            boolIDs.append([Bool](repeating: false, count: strArray.count))
        }
        print(stringIDs)
    }
    
    @IBAction func confirmReport(_ sender: Any) {
        showReportOptionsAlert()
    }
    
    @IBAction func markAsDone(_ sender: Any) {
        showMarkAsDoneOptionsAlert()
    }
    
    func showReportOptionsAlert() {
        let alertController = UIAlertController(title: "กรุณาตรวจสอบ ID หมู", message: "ID ของหมูที่เลือกทั้งหมด\nเป็นหมูตัวที่ยังทำงานไม่เสร็จ\nและจะเลื่อนงานไปทำต่อในวันพรุ่งนี้\nต้องการดำเนินการต่อหรือไม่", preferredStyle: UIAlertController.Style.alert)
        
        let actionNothing = UIAlertAction(title: "ยกเลิก", style: UIAlertAction.Style.cancel)
        
        let actionReport = UIAlertAction(title: "เลื่อนไปทำพรุ่งนี้     ", style: UIAlertAction.Style.destructive) { action in
            self.report()
            self.performSegue(withIdentifier: "reportToHome", sender: self)
        }
        
        alertController.addAction(actionReport)
        alertController.addAction(actionNothing)

        present(alertController, animated: true)
    }
    
    func showMarkAsDoneOptionsAlert() {
        let alertController = UIAlertController(title: "กรุณาตรวจสอบ ID หมูที่เลือก", message: "งานที่เหลือทั้งหมด\nเมื่อเปลี่ยนสถานะแล้วจะไม่สามารถแก้ไขได้", preferredStyle: UIAlertController.Style.alert)
        
        let actionNothing = UIAlertAction(title: "ยกเลิก", style: UIAlertAction.Style.cancel)
        
        let actionReport = UIAlertAction(title: "เปลี่ยนสถานะงานเป็น \"เสร็จแล้ว\"", style: UIAlertAction.Style.destructive) { action in
            self.markAsDone()
            self.performSegue(withIdentifier: "reportToHome", sender: self)
        }
        
        alertController.addAction(actionReport)
        alertController.addAction(actionNothing)
        
        present(alertController, animated: true)
    }
    
    func report() {
        for i in 0...workList.count-1 {
            print(workList[i])
            print(intIDs[i])
            print(boolIDs[i])
            self.reportWorkForTomorrow(atIndex: i, currentWork: workList[i], ids: intIDs[i], bools: boolIDs[i], date: Date())
        }
    }
    
    func reportWorkForTomorrow(atIndex:Int, currentWork:String, ids:[Int], bools:[Bool], date:Date) {
        let todayPath = "งาน/\(dateFormat.string(from: date))W/\(currentWork)"
        
        ref.child("\(todayPath)").observeSingleEvent(of: .value, with: { (snapshot) in
            let data = snapshot.value as! NSDictionary
            
            let pigtype = data["pigtype"] as! String
            let workstep = data["workstep"] as! Int
            let wName = workData.getAt(type: pigtype).name
            
            var indexToRemove:[Int] = []
            
            for i in 0...ids.count-1 {
                if bools[i] {
                    indexToRemove.append(i)
                    
//                    //  setValue 2 is UNDONE
//                    ref.child("\(todayPath)/\(ids[i])").setValue(2)
//
//
//                    let wDateRemain = workData.getAt(type: pigtype).generateWorkDate(date: date, fromIndex: workstep + 1)
//                    let wDate2morrow = tomorrow(date: wDateRemain)
//
//
//                    for j in 0...wDateRemain.count-1 {
//                        //  remove and reassign remain
//
//                        ref.child("งาน/\(dateFormat.string(from: wDateRemain[j]))W/\(wName[workstep+j+1])/\(ids[i])").removeValue()
//
//
//                        ref.child("งาน/\(dateFormat.string(from: wDate2morrow[j]))W/\(wName[workstep+j+1])/\(ids[i])").setValue(0)
//                        ref.child("งาน/\(dateFormat.string(from: wDate2morrow[j]))W/\(wName[workstep+j+1])/pigtype").setValue(pigtype)
//                        ref.child("งาน/\(dateFormat.string(from: wDate2morrow[j]))W/\(wName[workstep+j+1])/workstep").setValue(workstep+j+1)
//                    }
//
//                    //  assign tomorrow
//                    ref.child("งาน/\(dateFormat.string(from: tomorrow(date: date)))W/\(currentWork)/\(ids[i])").setValue(0)
//                    ref.child("งาน/\(dateFormat.string(from: tomorrow(date: date)))W/\(currentWork)/pigtype").setValue(pigtype)
//                    ref.child("งาน/\(dateFormat.string(from: tomorrow(date: date)))W/\(currentWork)/workstep").setValue(workstep)
                    
                }
                
            }
            
            //  .reversed
            //  prevent remove index out of range
            for i in indexToRemove.reversed() {
                workInfo[currentWork]?.remove(at: i)
            }
            if (workInfo[currentWork]?.isEmpty)! {
                workInfo.removeValue(forKey: currentWork)
                workList.remove(at: atIndex)
            }
        })
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
    
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if let controller = segue.destination as? WorkReport2ViewController,
//            let indexPath = tableView.indexPathForSelectedRow {
//            controller.idSelect = workInfo[workList[indexPath.row]]!
//            controller.titleBar.title = workList[indexPath.row]
//            print(workInfo)
//        }
//    }
    
//    @IBAction func unwindToWorkTable(_ unwindSegue: UIStoryboardSegue) { }

}

extension WorkReport1ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stringIDs[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return workList[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workcell", for: indexPath)
        cell.textLabel?.text = stringIDs[indexPath.section][indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType != UITableViewCell.AccessoryType.checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
            boolIDs[indexPath.section][indexPath.row] = true
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
            boolIDs[indexPath.section][indexPath.row] = false
        }
        print(boolIDs)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return workList.count
    }


    
}
