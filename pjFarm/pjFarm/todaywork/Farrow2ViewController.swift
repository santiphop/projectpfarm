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
    
    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var all: NumpadTextField!
    @IBOutlet weak var dead: NumpadTextField!
    @IBOutlet weak var mummy: NumpadTextField!
    @IBOutlet weak var maleLeft: NumpadTextField!
    @IBOutlet weak var femaleLeft: NumpadTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func save(_ sender: Any) {
        var intAll:Int = 0
        var intDead:Int = 0
        var intMummy:Int = 0
        var intMale:Int = 0
        var intFemale:Int = 0
        
        if (dead.text?.isEmpty)! {
            dead.text! = "0"
        }
        
        if (mummy.text?.isEmpty)! {
            mummy.text! = "0"
        }

        
        if !(all.text?.isEmpty)! {
            intAll = Int(all.text!)!
        }
        if !(dead.text?.isEmpty)! {
            intDead = Int(dead.text!)!
        }
        if !(mummy.text?.isEmpty)! {
            intMummy = Int(mummy.text!)!
        }
        if !(mummy.text?.isEmpty)! {
            intMale = Int(maleLeft.text!)!
        }
        if !(mummy.text?.isEmpty)! {
            intFemale = Int(femaleLeft.text!)!
        }
        
        
        if intDead + intMummy + intMale + intFemale == intAll && intAll > 0 {
//            ref.child("หมู/\(mom)/แม่พันธุ์/currentState").observeSingleEvent(of: .value) { (snapshot) in
//                let data = snapshot.value as! NSDictionary
//                let primary = data["primary"] as! Int
//                let secondary = data["secondary"] as! Int
//            }
            regisKK(id: mom, dad: dad, date: date, all: intAll, dead: intDead, mummy: intMummy, male: intMale, female: intFemale)
            showOptionsAlert()
        } else {
            showMessage(title: "ลงทะเบียนไม่สำเร็จ", message: "ข้อมูลไม่ถูกต้อง")
        }
    }
    
    func showOptionsAlert() {
        let alertController = UIAlertController(title: "Yeah!", message: "Saved the history to database: \(mom)", preferredStyle: UIAlertController.Style.alert)
        
        let actionBackHome = UIAlertAction(title: "Home", style: UIAlertAction.Style.default) { action in
            self.performSegue(withIdentifier: "KlodDoneToHome", sender: self)
        }
        
        let actionBackFarrow = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { action in
            self.performSegue(withIdentifier: "farrow2to1", sender: self)
        }
        alertController.addAction(actionBackHome)
        alertController.addAction(actionBackFarrow)

        present(alertController, animated: true)
        
        
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
    }
    
    func showMessage(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        present(alertController, animated: true)
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
