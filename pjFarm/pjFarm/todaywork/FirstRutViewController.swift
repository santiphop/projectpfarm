//
//  FirstRutViewController.swift
//  pjFarm
//
//  Created by Santiphop on 4/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class FirstRutViewController: UIViewController {

    var datePicker = UIDatePicker()    

    @IBOutlet weak var idTextField: NumpadTextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBAction func saveButton(_ sender: Any) {
        let idString = idTextField.text!
        ref.child("หมู/\(idString)").observeSingleEvent(of: .value) { (snapshot) in
            if idString.isEmpty {
                self.showMessage(title: "ลงทะเบียนไม่สำเร็จ", message: "ข้อมูลไม่ถูกต้อง กรุณาใส่ ID แม่พันธุ์")
            } else if let data = snapshot.value as? NSDictionary {
                if (data["สถานะ"] as! String).elementsEqual("หมูสาว") {
                    regisMP(id: idString, date: self.datePicker.date, primary: 1, secondary: 1)
                    self.showHomeOKAlert(title: "เปลี่ยนเป็นแม่พันธุ์ !", message: "ID ของแม่พันธุ์ : \(idString)", unwindToHome: "unwindRutToHome")
                } else {
                    self.showMessage(title: "สถานะผิดพลาด", message: "ID:\(idString) มีสถานะที่ไม่ใช่หมูสาว")
                }
            }
            else {
                self.showMessage(title: "ไม่พบข้อมูล", message: "ข้อมูลไม่ถูกต้อง\nID:\(idString) ไม่มีอยู่ในระบบ")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createDatePicker(datePicker: datePicker, textField: dateTextField, done: UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneActionForDatePicker)))
        dateTextField.text! = dateFormatForTextField.string(from: Date())
    }
    
    @objc func doneActionForDatePicker() {
        dateTextField.text = dateFormatForTextField.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
}

