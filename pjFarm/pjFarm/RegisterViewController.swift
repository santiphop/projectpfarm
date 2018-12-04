//
//  RegisterViewController.swift
//  pjFarm
//
//  Created by Santiphop on 27/11/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var currentID:Int = 0
    
    @IBOutlet weak var momTextField: UITextField! {
        didSet {
            momTextField?.addDoneToolbar(onDone: (target: self, action: #selector(doneButtonTappedForMomTextField)))
            momTextField.keyboardType = UIKeyboardType.numberPad
        }
    }
    @objc func doneButtonTappedForMomTextField() { momTextField.resignFirstResponder() }

    @IBOutlet weak var dad: UISegmentedControl!
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var dateTextField: UITextField!
    @IBAction func registerButton(_ sender: Any) {
        
        let db = self.appDelegate.db
        
        var dadString:String = ""
        let momString:String = momTextField.text!
        var genderString:String = ""
        
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
        
        currentID = db.regisMS(dad: dadString, mom: momString, gender: genderString, date:datePicker.date)
        showOptionsAlert()
    }
    
    var datePicker:UIDatePicker = UIDatePicker()
    
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
        let dateFormatForTextField = DateFormatter()
        dateFormatForTextField.dateFormat = "MMMM d, yyyy"
        dateTextField.text = dateFormatForTextField.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    func showOptionsAlert() {
        let alertController = UIAlertController(title: "Yeah!", message: "This pig ID is : \(self.currentID)", preferredStyle: UIAlertController.Style.alert)
        
        let actionNothing = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action) in }
        
        let actionBackHome = UIAlertAction(title: "Home", style: UIAlertAction.Style.default) { action in
            self.performSegue(withIdentifier: "unwindRegisterToHome", sender: self)
        }
        
        alertController.addAction(actionBackHome)
        alertController.addAction(actionNothing)

        present(alertController, animated: true, completion: nil)
        
        
    }

}

extension UITextField {
    func addDoneToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        self.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonTapped() { self.resignFirstResponder() }
 
}
