//
//  SearchByIDViewController.swift
//  pjFarm
//
//  Created by Santiphop on 18/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class SearchByIDViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var id = String()
    var autoSearch = Bool()
    
    
    var currentPigList = [String]()
    var currentPigInfo = [String:[String]]()

    
    @IBOutlet weak var idTextField: NumpadTextField!
    @IBAction func searchButton(_ sender: Any) {
        id = idTextField.text!
        search()
        idTextField.text! = ""
    }
    @IBOutlet weak var pigInfoView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if autoSearch { search() }
    }
    
    func search() {
        let db = appDelegate.db
        
        currentPigList = db.pigList
        currentPigInfo = db.pigInfo
        if currentPigInfo[id] != nil {
            pigInfoView.text = "ID: \(id)\nรหัสของแม่พันธุ์: \(currentPigInfo[id]![0])\nพันธุ์ของพ่อ: \(currentPigInfo[id]![1])\nวันแรกเข้า: \(currentPigInfo[id]![2])"
        } else {
            showExceptionAlert()
        }
    }
    
    func showExceptionAlert() {
        let alertController = UIAlertController(title: "ค้นหาไม่สำเร็จ", message: "ข้อมูลไม่ถูกต้อง กรุณาตรวจสอบ ID ที่ต้องการค้นหา", preferredStyle: UIAlertController.Style.alert)
        
        let actionNothing = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action) in }
        
        alertController.addAction(actionNothing)
        
        present(alertController, animated: true, completion: nil)
        
        
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
