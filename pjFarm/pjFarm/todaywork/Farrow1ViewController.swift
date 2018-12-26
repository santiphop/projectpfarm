//
//  KlodViewController.swift
//  pjFarm
//
//  Created by Santiphop on 17/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class Farrow1ViewController: UIViewController {
    let datePicker = UIDatePicker()

    //  for prepare()
    //  send data to next ViewController
    var momString = String()
    var dadString = String()
    
    @IBOutlet weak var momTextField: NumpadTextField!
    @IBOutlet weak var dad: UISegmentedControl!
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBAction func nextButton(_ sender: Any) {
        momString = momTextField.text!
        dadString = dadArray[dad.selectedSegmentIndex]
        ref.child("หมู/\(momString)").observeSingleEvent(of: .value) { (snapshot) in
            if self.momTextField.text!.isEmpty {
                self.showMessage(title: "ลงทะเบียนไม่สำเร็จ", message: "ข้อมูลไม่ถูกต้อง กรุณาใส่ ID แม่พันธุ์")
            } else if let data = snapshot.value as? NSDictionary {
                if (data["สถานะ"] as! String).elementsEqual("แม่พันธุ์") {
                    self.performSegue(withIdentifier: "farrow1to2", sender: self)
                } else {
                    self.showMessage(title: "สถานะผิดพลาด", message: "ID:\(self.momString) มีสถานะที่ไม่ใช่แม่พันธุ์")
                }
            } else {
                self.showMessage(title: "ไม่พบข้อมูล", message: "ข้อมูลไม่ถูกต้อง\nID:\(self.momString) ไม่มีอยู่ในระบบ")
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? Farrow2ViewController {
            controller.mom = momString
            controller.dad = dadString
            controller.date = datePicker.date
            controller.titleBar.title = momString
        }
    }
    
    @IBAction func unwindToFarrow(_ unwindSegue: UIStoryboardSegue) { }

}


