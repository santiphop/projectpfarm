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
        //  success
        let idString = idTextField.text!
        ref.child("หมู/\(idString)").observeSingleEvent(of: .value) { (snapshot) in
            if idString.isEmpty {
                self.showMessage(title: "ลงทะเบียนไม่สำเร็จ", message: "ข้อมูลไม่ถูกต้อง กรุณาใส่ ID แม่พันธุ์")
            } else if let data = snapshot.value as? NSDictionary {
                if (data["สถานะ"] as! String).elementsEqual("หมูสาว") {
                    regisMP(date: self.datePicker.date, id: idString, primary: 1, secondary: 1)
                    self.showOptionsAlert()
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
        createDatePicker()
        dateFormatForTextField.dateFormat = "MMMM d, yyyy"
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
    
    func showOptionsAlert() {
        let alertController = UIAlertController(title: "Yeah!", message: "This pig ID is : \(idTextField.text!)", preferredStyle: UIAlertController.Style.alert)
        
        let actionNothing = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action) in }
        
        let actionBackHome = UIAlertAction(title: "Home", style: UIAlertAction.Style.default) { action in
            self.performSegue(withIdentifier: "unwindRutToHome", sender: self)
        }
        
        alertController.addAction(actionBackHome)
        alertController.addAction(actionNothing)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    func showMessage(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        present(alertController, animated: true)
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

