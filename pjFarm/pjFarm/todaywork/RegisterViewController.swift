//
//  RegisterViewController.swift
//  pjFarm
//
//  Created by Santiphop on 27/11/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    let datePicker = UIDatePicker()
    var amount = Int()
    var momID = String()
    let leastID = currentID + 1

    var maxAmount = Int()
    
    @IBOutlet weak var momLabel: UILabel!
    @IBOutlet weak var dad: UISegmentedControl!{
        didSet {
            let font = UIFont.systemFont(ofSize: 18)
            dad.setTitleTextAttributes([NSAttributedString.Key.font : font], for: .normal)
        }
    }
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var minusButton: RoundButton!
    @IBOutlet weak var plusButton: RoundButton!
    
    func updateAmountLabel() {
        amountLabel.text! = String(amount)

        if amount <= 1 {
            minusButton.isEnabled = false
        } else if amount >= maxAmount {
            plusButton.isEnabled = false
        } else {
            minusButton.isEnabled = true
            plusButton.isEnabled = true
        }
    }
    
    @IBAction func minus(_ sender: Any) {
        if amount > 1 {
            amount -= 1
            updateAmountLabel()
        }
    }
    
    @IBAction func plus(_ sender: Any) {
        if amount < maxAmount {
            amount += 1
            updateAmountLabel()
        }
    }
    
    @IBAction func registerButton(_ sender: Any) {
        let momString = momID
        let dadString = dadArray[dad.selectedSegmentIndex]
        
        if momString.isEmpty || momString.count != 4 {
            showMessage(title: "ลงทะเบียนไม่สำเร็จ", message: "ข้อมูลไม่ถูกต้อง กรุณาใส่ ID แม่พันธุ์ของหมู\n(ข้อมูล ID ของแม่พันธุ์ 4 หลัก)")
        }
        else {
            regisMS(mom: momString, dad: dadString, date:datePicker.date)
            if amount == 1 {
                showHomeAlert(title: "ลงทะเบียนสำเร็จ !", message: "ID ของหมูตัวใหม่ : \(currentID)", unwindToHome: "unwindRegisterToHome")
            } else {
                showHomeAlert(title: "ลงทะเบียนสำเร็จ !", message: "ID ของหมูตัวใหม่ : \(leastID) - \(currentID)", unwindToHome: "unwindRegisterToHome")
            }
        }
    }
    
    func setUpMaxAmount() {
        ref.child("หมู/\(momID)/แม่พันธุ์/จำนวนลูกหมูเพศเมีย").observeSingleEvent(of: .value) { (snapshot) in
            self.maxAmount = snapshot.value as! Int
            print(self.maxAmount)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        momLabel.text! = momID
        createDatePicker(datePicker: datePicker, textField: dateTextField, button: UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneActionForDatePicker)))
        dateTextField.text! = dateFormatForTextField.string(from: Date())
        amount = 1
        updateAmountLabel()
        setUpMaxAmount()
    }
    
    @objc func doneActionForDatePicker() {
        dateTextField.text = dateFormatForTextField.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    func regisMS(mom:String, dad:String, date:Date) {
        for _ in 1...amount {
            currentID += 1
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
            addPig(type: "หมูสาว", id: "\(currentID)")
        }
    }

}


