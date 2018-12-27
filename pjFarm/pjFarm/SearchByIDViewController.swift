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
        let id = self.id
        var output = "ID : \(id)\n"
        ref.child("หมู/\(id)").observeSingleEvent(of: .value) { (snapshot) in
            if let data = snapshot.value as? NSDictionary {
                
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
                
            } else {
                self.showMessage(title: "ค้นหาไม่สำเร็จ", message: "ข้อมูลไม่ถูกต้อง กรุณาตรวจสอบ ID ที่ต้องการค้นหา")
            }
        }
    }
    

}
