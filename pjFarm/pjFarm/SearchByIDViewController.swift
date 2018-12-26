//
//  SearchByIDViewController.swift
//  pjFarm
//
//  Created by Santiphop on 18/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class SearchByIDViewController: UIViewController {
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

//        let db = appDelegate.db
//        print(db.pigInfo)
        // Do any additional setup after loading the view.
        if autoSearch { search() }
    }
    
    func search() {
        let id = self.id
        var output = "ID : \(id)\n"
        ref.child("หมู/\(id)").observeSingleEvent(of: .value) { (snapshot) in
            if let data = snapshot.value as? NSDictionary {
//                ref.child("หมู/\(id)/ประวัติ").observeSingleEvent(of: .value, with: { (intersnapshot) in
//                    let musao = intersnapshot.value as! NSDictionary
//                    output += musao["พ่อพันธุ์"] as! String
//                })
                output += "สถานะ: \(data["สถานะ"] as! String)\n"
                
                let ms = data["หมูสาว"] as! NSDictionary
                let hist = ms["ประวัติ"] as! NSDictionary
                output += "พ่อพันธุ์: \(hist["พ่อพันธุ์"] as! String)\n"
                output += "แม่พันธุ์: \(hist["แม่พันธุ์"] as! String)\n"
                output += "วันแรกเข้า: \(hist["วันแรกเข้า"] as! String)\n"
                
                //  แม่พันธุ์
                //  คอกคลอด
                //  คอกอนุบาล
                //  เพิ่มเติมได้ในภายหลัง
                
                self.pigInfoView.text = output
            } else {
                self.showMessage(title: "ค้นหาไม่สำเร็จ", message: "ข้อมูลไม่ถูกต้อง กรุณาตรวจสอบ ID ที่ต้องการค้นหา")
            }
        }
//        if currentPigInfo[id] != nil {
//            pigInfoView.text = "ID: \(id)\nรหัสของแม่พันธุ์: \(currentPigInfo[id]![0])\nพันธุ์ของพ่อ: \(currentPigInfo[id]![1])\nวันแรกเข้า: \(currentPigInfo[id]![2])"
//        } else {
//            showExceptionAlert()
//        }
    }
    

    func showMessage(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        self.present(alertController, animated: true)
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
