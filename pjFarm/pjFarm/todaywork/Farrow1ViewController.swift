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
        createDatePicker()
        dateTextField.text! = dateFormatForTextField.string(from: Date())
    }
    
    func createDatePicker() {
        datePicker.datePickerMode = .date
        let onDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneActionForDatePicker))
        let toolbar:UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
    }
    
    @objc func doneActionForDatePicker() {
        dateTextField.text = dateFormatForTextField.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! Farrow2ViewController
        controller.mom = momString
        controller.dad = dadString
        controller.date = datePicker.date
        controller.titleBar.title = momString
    }
    
    func showMessage(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        present(alertController, animated: true)
    }
    
    @IBAction func unwindToFarrow(_ unwindSegue: UIStoryboardSegue) { }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


