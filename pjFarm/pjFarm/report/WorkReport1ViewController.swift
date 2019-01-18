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
    
    //  send to WR2VC
    var selectedSection = [String]()
    var selectedRow = [[String]]()
    var selectedID = [[Int]]()
    
    //  send to WorkVC
    var isAction = false

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
    
    /*
     
     // Mark as Done Button
     
     */
    
    @IBAction func markAsDone(_ sender: Any) {
        showMarkAsDoneOptionsAlert()
    }
    
    func showMarkAsDoneOptionsAlert() {
        let alertController = UIAlertController(title: "กรุณาตรวจสอบ ID หมู", message: "งานที่เหลือทั้งหมด\nเมื่อเปลี่ยนสถานะแล้ว\nจะไม่สามารถแก้ไขได้", preferredStyle: UIAlertController.Style.alert)
        
        let actionNothing = UIAlertAction(title: "ยกเลิก", style: UIAlertAction.Style.cancel)
        
        let actionReport = UIAlertAction(title: "เปลี่ยนงานทั้งหมดเป็น \"เสร็จแล้ว\"", style: UIAlertAction.Style.destructive) { action in
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
            self.isAction = true
        }
    }
    
    /*
     
     // Next Button
     
     */
    
    @IBAction func next(_ sender: Any) {
        var containsTrue = false
        for section in boolIDs {
            if section.contains(true) {
                containsTrue = true
            }
        }

        if containsTrue {
            performSegue(withIdentifier: "report1to2", sender: self)
        } else {
            showMessage(title: "ยังไม่ได้ทำการเลือก", message: "กรุณาเลือกงานที่ยังทำไม่เสร็จ\nหากไม่มี กดปุ่ม ✔️ ด้านขวาบน")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? WorkViewController, isAction {
            controller.disableShareButton()
        }
        if let controller = segue.destination as? WorkReport2ViewController {
            self.setupWR2VCsTable()
            controller.selectedSection = self.selectedSection
            controller.selectedRow = self.selectedRow
            controller.selectedID = self.selectedID
        }
    }
    
    func setupWR2VCsTable() {
        selectedSection = workList
        selectedRow.removeAll()
        selectedID.removeAll()
        var indexToRemove = [Int]()
        for section in 0...workList.count-1 {
            selectedRow.append([])
            selectedID.append([])
            for row in 0...intIDs[section].count-1 {
                if boolIDs[section][row] {
                    selectedRow[section].append("\(intIDs[section][row])")
                    selectedID[section].append(intIDs[section][row])
                }
            }
            if selectedRow[section].isEmpty {
                indexToRemove.append(section)
            }
        }
        
        //  .reversed
        //  prevent remove index out of range
        for index in indexToRemove.reversed() {
            selectedID.remove(at: index)
            selectedRow.remove(at: index)
            selectedSection.remove(at: index)
        }
    }
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
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 25)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType != UITableViewCell.AccessoryType.checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
//            tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.
            boolIDs[indexPath.section][indexPath.row] = true
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
            boolIDs[indexPath.section][indexPath.row] = false
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return workList.count
    }
}
