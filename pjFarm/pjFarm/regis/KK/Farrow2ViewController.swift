//
//  KlodAmountViewController.swift
//  pjFarm
//
//  Created by Santiphop on 17/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class Farrow2ViewController: UIViewController {
    var mom = String()
    var dad = String()
    var date = Date()
    
    let maxAmount = 20
    var intAll:Int = 0
    var intDead:Int = 0
    var intMummy:Int = 0
    var intMale:Int = 0
    var intFemale:Int = 0
    
    @IBOutlet weak var warningAmount: UILabel!
    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var all: NumpadTextField!
    @IBOutlet weak var dead: NumpadTextField!
    @IBOutlet weak var mummy: NumpadTextField!
    @IBOutlet weak var maleLeft: NumpadTextField!
    @IBOutlet weak var femaleLeft: NumpadTextField!
    @IBAction func save(_ sender: Any) {
        if (intAll > 20){
            showMessage(title: "ลงทะเบียนไม่สำเร็จ", message: "จำนวนหมูทั้งหมดต้องไม่เกิน 20 ตัว")
        } else if (intDead + intMummy + intMale + intFemale == intAll && intAll > 0) {
            regisKK(id: mom, dad: dad, date: date, all: intAll, dead: intDead, mummy: intMummy, male: intMale, female: intFemale)
            showHomeAlert(title: "แม่พันธุ์ทำการคลอด !", message: "ID ของแม่พันธุ์และคอกคลอด : \(mom)", unwindToHome: "KlodDoneToHome")
        } else {
            showMessage(title: "ลงทะเบียนไม่สำเร็จ", message: "ข้อมูลไม่ถูกต้อง")
        }
    }
    
    @IBAction func femaleTouchDown(_ sender: Any) {
        if !((maleLeft.text?.isEmpty)!) {
            let left = intAll - intDead - intMummy - intMale
            if left >= 0 {
                femaleLeft.text! = "\(left)"
                intFemale = left
                print(intFemale)
            }
        }
    }
    
    @IBAction func maleTouchDown(_ sender: Any) {
        if !(femaleLeft.text?.isEmpty)! {
            let left = intAll - intDead - intMummy - intFemale
            if left >= 0 {
                maleLeft.text = "\(left)"
                intMale = left
                print(intMale)
            }
        }
    }
    
    @IBAction func allEdit(_ sender: Any) {
        warningAmount.text = ""
        if (all.text?.isEmpty)! {
            intAll = 0
        } else {
            intAll = Int(all.text!)!
            if (intAll > 20){
                warningAmount.text = "ไม่สามารถใส่จำนวนเกิน 20 ตัว"
                all.layer.borderColor = UIColor.red.cgColor
            }
        }
    }
    
    @IBAction func deadEdit(_ sender: Any) {
        if (dead.text?.isEmpty)! {
            intDead = 0
        } else {
            intDead = Int(dead.text!)!
        }
    }
    
    @IBAction func mummyEdit(_ sender: Any) {
        if (mummy.text?.isEmpty)! {
            intMummy = 0
        } else {
            intMummy = Int(mummy.text!)!
        }
    }
    
    @IBAction func maleEdit(_ sender: Any) {
        if (maleLeft.text?.isEmpty)! {
            intMale = 0
        } else {
            intMale = Int(maleLeft.text!)!
        }
    }
    
    @IBAction func femaleEdit(_ sender: Any) {
        if (femaleLeft.text?.isEmpty)! {
            intFemale = 0
        } else {
            intFemale = Int(femaleLeft.text!)!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    func regisKK(id:String, dad:String, date:Date, all:Int, dead:Int, mummy:Int, male:Int, female:Int) {
        workKokklod.generateSelf(date: date)
        ref.child("หมู/\(id)/แม่พันธุ์/currentState").observeSingleEvent(of: .value, with: { snapshot in
            let data = snapshot.value as? NSDictionary
            let primary = data?["primary"] as! Int
            let secondary = data?["secondary"] as! Int
            let remain = all-(dead+mummy)
            
            ref.child("หมู/\(id)/สถานะ").setValue("คอกคลอด")
            let kokklodPath = "หมู/\(id)/แม่พันธุ์/\(primary)/\(secondary)/คอกคลอด"
            ref.child("\(kokklodPath)/ประวัติการทำคลอด").setValue([
                "วันคลอด":dateFormat.string(from: date),
                "จำนวนลูกทั้งหมด":all,
                "จำนวนลูกที่ตาย":dead,
                "จำนวนลูกที่พิการ":mummy,
                "จำนวนลูกที่เหลือ":remain,
                "จำนวนลูกที่เหลือเพศผู้":male,
                "จำนวนลูกที่เหลือเพศเมีย":female
            ])
            for i in 0...workKokklod.name.count-1 {
                ref.child("\(kokklodPath)/งาน/\(workKokklod.name[i])").setValue(dateFormat.string(from: workKokklod.date[i]))
            }
            
        })
        
        assignWork(id: Int(id)!, work: workKokklod)
        addPig(type: "คอกคลอด", id: id)
    }
    

}
