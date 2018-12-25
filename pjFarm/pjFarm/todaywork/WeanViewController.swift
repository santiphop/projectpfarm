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
//                    self.regisKG(date: self.datePicker.date, id: momString)
                    print("regis")
                    self.showOptionsAlert()
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
        let alertController = UIAlertController(title: "Yeah!", message: "Saved the history to database: \(momTextField.text!)", preferredStyle: UIAlertController.Style.alert)
        
        let actionBackHome = UIAlertAction(title: "Home", style: UIAlertAction.Style.default) { action in
            self.performSegue(withIdentifier: "weanToHome", sender: self)
        }
        
        let actionNothing = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        
        alertController.addAction(actionBackHome)
        alertController.addAction(actionNothing)

        present(alertController, animated: true)
        
        
    }
    
    func showMessage(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        present(alertController, animated: true)
    }
    
    func regisKG(id:String, date:Date) {
        ref.child("หมู/\(id)/แม่พันธุ์").observeSingleEvent(of: .value, with: { snapshot in
            let data = snapshot.value as? NSDictionary
            let currentState = data?["currentState"] as? NSDictionary
            let primary = currentState?["primary"] as! Int
            let secondary = currentState?["secondary"] as! Int
            let remain = data?["\(primary)/\(secondary)/คอกคลอด/ประวัติการทำคลอด/จำนวนลูกที่เหลือ"] as! Int
            
            ref.child("หมู/\(id)/สถานะ").setValue("แม่พันธุ์")
            let kinderPath = "หมู/\(id)/แม่พันธุ์/\(primary)/\(secondary)/คอกอนุบาล"
            ref.child("\(kinderPath)/จำนวนหมู").setValue(remain)
            for i in 0...workKinderg.name.count-1 {
                ref.child("\(kinderPath)/งาน/\(workKinderg.name[i])").setValue(dateFormat.string(from: workKinderg.date[i]))
            }
            regisMP(date: date, id: id, primary: primary+1, secondary: 1)
        })
        
        assignWork(id: Int(id)!, work: workKinderg)
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
