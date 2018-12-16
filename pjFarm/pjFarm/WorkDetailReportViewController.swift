//
//  WorkDetailReportViewController.swift
//  pjFarm
//
//  Created by Santiphop on 7/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class WorkDetailReportViewController: UIViewController {
    
    var idSelect = [Int]()
    var detailSelect = [Bool]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let pigPath = ""
    

    @IBOutlet weak var titleBar: UINavigationItem!
    @IBAction func reportButton(_ sender: Any) {
        print(detailSelect)
        print(idSelect)
        let db = appDelegate.db
        db.reportWorkMusao(ids: idSelect, bools: detailSelect, date:Date())
        performSegue(withIdentifier: "detailToReportSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        for _ in 0...idSelect.count - 1 {
            detailSelect.append(false)
        }
        
        
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

extension WorkDetailReportViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return idSelect.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workdetailcell", for: indexPath)
        cell.textLabel?.text = "\(idSelect[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
            detailSelect[indexPath.row] = false
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
            detailSelect[indexPath.row] = true
        }
    }
}
