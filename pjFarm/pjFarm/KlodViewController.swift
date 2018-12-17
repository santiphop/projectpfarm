//
//  KlodViewController.swift
//  pjFarm
//
//  Created by Santiphop on 17/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class KlodViewController: UIViewController {
    
    /*
     รหัสแม่
     พันธุ์พ่อ
     วันที่คลอด
     จำนวนลูกทั้งหมด
     จำนวนลูกที่ตาย
     พิการ
     เหลือ
     ผู้เหลือ
     เมียเหลือ
     */
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var datePicker = UIDatePicker()
    let dateFormatForTextField = DateFormatter()
    
    @IBOutlet weak var momTextField: UITextField! {
        didSet {
            momTextField.removeCursor()
            momTextField?.addDoneToolbar(onDone: (target: self, action: #selector(doneButtonTappedForMomTextField)))
            momTextField.keyboardType = UIKeyboardType.numberPad
        }
    }
    @IBOutlet weak var dad: UISegmentedControl!
    
    @objc func doneButtonTappedForMomTextField() { momTextField.resignFirstResponder() }

    
    @IBOutlet weak var dateTextField: UITextField! {
        didSet {
            dateTextField.removeCursor()
        }
    }
    
    @IBAction func nextButton(_ sender: Any) {
        let db = appDelegate.db
        var momString = ""
        
        var dadString = ""
        momString = momTextField.text!
        if dad.selectedSegmentIndex == 0 {
            dadString = ("LW")
        }
        if dad.selectedSegmentIndex == 1 {
            dadString = ("DR")
        }
        if dad.selectedSegmentIndex == 2 {
            dadString = ("LR")
        }
        db.getIDMaepun(id: momString)
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
        let db = self.appDelegate.db
//        db.generateWorkIDCountForMusao()
//        db.generateWorkDateForMusao(date: datePicker.date)
        
        self.view.endEditing(true)
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
