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
        let db = self.appDelegate.db
        let momString:String = momTextField.text!
        let dadString:String = dadArray[dad.selectedSegmentIndex]
        
        if momString.isEmpty {
            showMomExceptionAlert()
        }
        else {
            let currentID = db.regisMS(dad: dadString, mom: momString, date:datePicker.date)
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
        let db = self.appDelegate.db
        db.generateWorkDateForMusao(date: datePicker.date)
        db.generateWorkIDCountForMusao()
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
    
    func showMomExceptionAlert() {
        let alertController = UIAlertController(title: "ลงทะเบียนไม่สำเร็จ", message: "ข้อมูลไม่ถูกต้อง กรุณาใส่ ID แม่พันธุ์ของหมู", preferredStyle: UIAlertController.Style.alert)
        
        let actionNothing = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action) in }
        
        alertController.addAction(actionNothing)
        
        present(alertController, animated: true, completion: nil)
        
        
    }

}


