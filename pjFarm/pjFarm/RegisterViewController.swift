//
//  RegisterViewController.swift
//  pjFarm
//
//  Created by Santiphop on 27/11/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var mom: UITextField!
    @IBOutlet weak var dad: UISegmentedControl!
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var dateTextField: UITextField!
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var datePicker = UIDatePicker()
    var numPicker = UIKeyboardType.numberPad
    
    
    @IBOutlet weak var momTextField: UITextField! {
        didSet {
            momTextField?.addDoneCancelToolbar(onDone: (target: self, action: #selector(doneButtonTappedForMyNumericTextField)))
            momTextField.keyboardType = UIKeyboardType.numberPad
        }
    }
    
    @IBAction func registerButton(_ sender: Any) {
        let db = self.appDelegate.db
        var dadString:String = ""
        let momString:String = momTextField.text!
        var genderString:String = ""
        print(mom.text!)
        if dad.selectedSegmentIndex == 0 {
            dadString = ("LW")
        }
        if dad.selectedSegmentIndex == 1 {
            dadString = ("DR")
        }
        if dad.selectedSegmentIndex == 2 {
            dadString = ("LR")
        }
        if gender.selectedSegmentIndex == 0 {
            genderString = ("Male")
        }
        if gender.selectedSegmentIndex == 1 {
            genderString = ("Female")
        }
        
        db.regisMS(dad: dadString, mom: momString, gender: genderString)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createDatePicker()
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
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        
        toolbar.setItems([doneButton], animated: true)
        dateTextField.inputAccessoryView = toolbar
        
        dateTextField.inputView = datePicker
    }
    
    @objc func doneAction() {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM-dd-yyyy"
        
        
        dateTextField.text = dateFormat.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func doneButtonTappedForMyNumericTextField() {
        print("Done");
        momTextField.resignFirstResponder()
    }

}

extension UITextField {
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    // Default actions:
    @objc func doneButtonTapped() { self.resignFirstResponder() }
    @objc func cancelButtonTapped() { self.resignFirstResponder() }
    
    
    
    
    
}
