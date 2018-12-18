//
//  KlodViewController.swift
//  pjFarm
//
//  Created by Santiphop on 17/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class KlodViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let datePicker = UIDatePicker()
    let dateFormatForTextField = DateFormatter()
    let dadArray = ["Large White", "Duroc", "Landrace"]

    //  for prepare()
    //  send data to next ViewController
    var momString = ""
    var dadString = ""
    
    @IBOutlet weak var momTextField: NumpadTextField!
    
    @IBOutlet weak var dad: UISegmentedControl!
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBAction func nextButton(_ sender: Any) {
        let db = appDelegate.db
        momString = momTextField.text!
        dadString = dadArray[dad.selectedSegmentIndex]
        db.getMaepunCurrentStateFrom(id: momString)
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
        let db = appDelegate.db
        db.generateWorkDateForKokKlod(date: datePicker.date)
        db.generateWorkIDCountForKokKlod()
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! KlodAmountViewController
        controller.mom = momString
        controller.dad = dadString
        controller.date = datePicker.date
        controller.titleBar.title = momString
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


