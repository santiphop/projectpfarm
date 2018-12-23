//
//  KlodViewController.swift
//  pjFarm
//
//  Created by Santiphop on 17/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class FarrowViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let datePicker = UIDatePicker()
    let dateFormatForTextField = DateFormatter()
    let dadArray = ["Large White", "Duroc", "Landrace"]
    var currentPigList = [String]()

    //  for prepare()
    //  send data to next ViewController
    var momString = ""
    var dadString = ""
    
    @IBOutlet weak var momTextField: NumpadTextField!
    
    @IBOutlet weak var dad: UISegmentedControl!
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBAction func nextButton(_ sender: Any) {
        let db = appDelegate.db
        currentPigList = db.pigList

        momString = momTextField.text!
        dadString = dadArray[dad.selectedSegmentIndex]
        if momString.isEmpty {
            showEmptyTextExceptionAlert()
        } else if !currentPigList.contains(momString) {
            showNoDataExceptionAlert(id: momString)
        }
        else {
            db.getMaepunCurrentStateFrom(id: momString)
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
        let db = appDelegate.db
//        db.generateWorkDateForKokKlod(date: datePicker.date)
//        db.generateWorkIDCountForKokKlod()
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! FarrowDetailViewController
        controller.mom = momString
        controller.dad = dadString
        controller.date = datePicker.date
        controller.titleBar.title = momString
    }
    
    func showEmptyTextExceptionAlert() {
        let alertController = UIAlertController(title: "ลงทะเบียนไม่สำเร็จ", message: "ข้อมูลไม่ถูกต้อง กรุณาใส่ ID แม่พันธุ์", preferredStyle: UIAlertController.Style.alert)
        
        let actionNothing = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action) in }
        
        alertController.addAction(actionNothing)
        
        present(alertController, animated: true, completion: nil)
        
        
    }
    
    func showNoDataExceptionAlert(id:String) {
        let alertController = UIAlertController(title: "ไม่พบข้อมูล", message: "ข้อมูลไม่ถูกต้อง\nID:\(id) ไม่มีอยู่ในระบบ", preferredStyle: UIAlertController.Style.alert)
        
        let actionNothing = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action) in }
        
        alertController.addAction(actionNothing)
        
        present(alertController, animated: true, completion: nil)
        
        
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


