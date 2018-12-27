//
//  WeanViewController.swift
//  pjFarm
//
//  Created by Santiphop on 17/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class WeanViewController: UIViewController {
    let datePicker = UIDatePicker()
    
    @IBOutlet weak var momTextField: NumpadTextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBAction func registerButton(_ sender: Any) {
        let momString = momTextField.text!
        
        ref.child("หมู/\(momString)").observeSingleEvent(of: .value) { (snapshot) in
            if momString.isEmpty {
                self.showMessage(title: "ลงทะเบียนไม่สำเร็จ", message: "ข้อมูลไม่ถูกต้อง กรุณาใส่ ID แม่พันธุ์")
            } else if let data = snapshot.value as? NSDictionary {
                if (data["สถานะ"] as! String).elementsEqual("คอกคลอด") {
                    self.regisKG(id: momString, date: self.datePicker.date)
                    self.showHomeOKAlert(title: "การย้ายคอกสำเร็จ !", message: "ID ของคอกอนุบาล : \(momString)", unwindToHome: "weanToHome")
                } else {
                    self.showMessage(title: "สถานะผิดพลาด", message: "ID:\(momString) ไม่ได้อยู่ในคอกคลอด")
                }
            }
            else {
                self.showMessage(title: "ไม่พบข้อมูล", message: "ข้อมูลไม่ถูกต้อง\nID:\(momString) ไม่มีอยู่ในระบบ")
            }
        }

//        if momString.isEmpty {
//            showEmptyTextExceptionAlert()
//        } else if !currentPigList.contains(momString) {
//            showNoDataExceptionAlert(id: momString)
//        }
//        else {
//            regisKG(id: momString, date: datePicker.date)
//            showOptionsAlert()
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createDatePicker(datePicker: datePicker, textField: dateTextField, button: UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneActionForDatePicker)))
        dateTextField.text! = dateFormatForTextField.string(from: Date())
    }
    
    
    @objc func doneActionForDatePicker() {
        dateTextField.text = dateFormatForTextField.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    func regisKG(id:String, date:Date) {
        workKinderg.generateSelf(date: date)
        ref.child("หมู/\(id)/แม่พันธุ์").observeSingleEvent(of: .value, with: { snapshot in
            let data = snapshot.value as? NSDictionary
            let currentState = data?["currentState"] as? NSDictionary
            let primary = currentState?["primary"] as! Int
            let secondary = currentState?["secondary"] as! Int
            let kinderPath = "หมู/\(id)/แม่พันธุ์/\(primary)/\(secondary)/คอกอนุบาล"

            ref.child("หมู/\(id)/แม่พันธุ์/\(primary)/\(secondary)/คอกคลอด/ประวัติการทำคลอด/จำนวนลูกที่เหลือ").observeSingleEvent(of: .value, with: { (intersnapshot) in
                let remain = intersnapshot.value as? Int
                ref.child("\(kinderPath)/จำนวนหมู").setValue(remain)
            })
            
            ref.child("หมู/\(id)/สถานะ").setValue("แม่พันธุ์")
            for i in 0...workKinderg.name.count-1 {
                ref.child("\(kinderPath)/งาน/\(workKinderg.name[i])").setValue(dateFormat.string(from: workKinderg.date[i]))
            }
            regisMP(id: id, date: date, primary: primary+1, secondary: 1)
        })
        assignWork(id: Int(id)!, work: workKinderg)
        
        /*
        // assignWorkMaepun is in regisMP above
        // assignWork(id: Int(id)!, work: workMaepun)
        */
    }


}
