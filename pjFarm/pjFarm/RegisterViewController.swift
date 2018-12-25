//
//  RegisterViewController.swift
//  pjFarm
//
//  Created by Santiphop on 27/11/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let datePicker = UIDatePicker()
    let dateFormatForTextField = DateFormatter()
    let dadArray = ["Large White", "Duroc", "Landrace"]
    
    @IBOutlet weak var momTextField: NumpadTextField!
    @IBOutlet weak var dad: UISegmentedControl!
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBAction func registerButton(_ sender: Any) {
//        let db = self.appDelegate.db
        let momString:String = momTextField.text!
        let dadString:String = dadArray[dad.selectedSegmentIndex]
        
        if momString.isEmpty || momString.count != 4 {
            showMessage(title: "ลงทะเบียนไม่สำเร็จ", message: "ข้อมูลไม่ถูกต้อง กรุณาใส่ ID แม่พันธุ์ของหมู\n(ข้อมูล ID ของแม่พันธุ์ 4 หลัก)")
        }
        else {
            regisMS(dad: dadString, mom: momString, date:datePicker.date)
            showOptionsAlert(id: currentID)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createDatePicker()
        dateFormatForTextField.dateFormat = "MMMM d, yyyy"
        dateTextField.text! = dateFormatForTextField.string(from: Date())
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
    
    func showOptionsAlert(id:Int) {
        let alertController = UIAlertController(title: "Yeah!", message: "This pig ID is : \(id)", preferredStyle: UIAlertController.Style.alert)
        
        let actionNothing = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action) in }
        
        let actionBackHome = UIAlertAction(title: "Home", style: UIAlertAction.Style.default) { action in
            self.performSegue(withIdentifier: "unwindRegisterToHome", sender: self)
        }
        
        alertController.addAction(actionBackHome)
        alertController.addAction(actionNothing)

        present(alertController, animated: true, completion: nil)
        
        
    }
    
    func showMessage(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        self.present(alertController, animated: true)
    }
    
    //  firebase
    func regisMS(dad:String, mom:String, date:Date) {
        currentID += 1
        
//        let musao = PigMusao(id: currentID, mother: mom, father: dad, date:date, work: workMusao)
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


