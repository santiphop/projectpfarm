//
//  RegisterViewController.swift
//  pjFarm
//
//  Created by Santiphop on 27/11/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    let datePicker = UIDatePicker()
    @IBOutlet weak var newID: UILabel!
    @IBOutlet weak var momTextField: NumpadTextField!
    @IBOutlet weak var dad: UISegmentedControl!
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBAction func registerButton(_ sender: Any) {
        let momString:String = momTextField.text!
        let dadString:String = dadArray[dad.selectedSegmentIndex]
        
        if momString.isEmpty || momString.count != 4 {
            showMessage(title: "ลงทะเบียนไม่สำเร็จ", message: "ข้อมูลไม่ถูกต้อง กรุณาใส่ ID แม่พันธุ์ของหมู\n(ข้อมูล ID ของแม่พันธุ์ 4 หลัก)")
        }
        else {
            regisMS(mom: momString, dad: dadString, date:datePicker.date)
            showHomeOKAlert(title: "ลงทะเบียนสำเร็จ !", message: "ID ของหมูตัวใหม่ : \(currentID)", unwindToHome: "unwindRegisterToHome")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        newID.text! = "\(currentID + 1)"
        createDatePicker(datePicker: datePicker, textField: dateTextField, button: UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneActionForDatePicker)))
        dateTextField.text! = dateFormatForTextField.string(from: Date())
    }
    
    @objc func doneActionForDatePicker() {
        dateTextField.text = dateFormatForTextField.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    func regisMS(mom:String, dad:String, date:Date) {
        currentID += 1
        workMusao.generateSelf(date: date)
        
        ref.child("หมู/currentID").setValue(currentID)
        ref.child("หมู/\(currentID)/สถานะ").setValue("หมูสาว")
        ref.child("หมู/\(currentID)/หมูสาว/ประวัติ").setValue([
            "แม่พันธุ์":mom,
            "พ่อพันธุ์":dad,
            "วันแรกเข้า":dateFormat.string(from: date)
        ])
        for i in 0...workMusao.name.count-1 {
            ref.child("หมู/\(currentID)/หมูสาว/งาน/\(workMusao.name[i])").setValue(dateFormat.string(from: workMusao.date[i]))
        }
        
        assignWork(id: currentID, work: workMusao)
    }

}


