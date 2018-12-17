//
//  KlodAmountViewController.swift
//  pjFarm
//
//  Created by Santiphop on 17/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class KlodAmountViewController: UIViewController {
    var mom = String()
    var dad = String()
    var date = Date()
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    @IBOutlet weak var all: NumpadTextField!
    @IBOutlet weak var dead: NumpadTextField!
    @IBOutlet weak var mummy: NumpadTextField!
    @IBOutlet weak var maleLeft: NumpadTextField!
    @IBOutlet weak var femaleLeft: NumpadTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(mom)
        print(dad)
        print(date)
        let db = appDelegate.db
        db.generateWorkIDCountForKokKlod()
    }
    
    @IBAction func save(_ sender: Any) {
        let intAll = Int(all.text!)!
        let intDead = Int(dead.text!)!
        let intMummy = Int(mummy.text!)!
        let intMale = Int(maleLeft.text!)!
        let intFemale = Int(femaleLeft.text!)!
        
        if intDead + intMummy + intMale + intFemale == intAll {
            let db = appDelegate.db
            db.writeKlodHistory(id: mom, dad: dad, date: date, all: intAll, dead: intDead, mummy: intMummy, male: intMale, female: intFemale)
            showOptionsAlert()
        } else {
            showExceptionAlert()
        }
    }
    
    func showOptionsAlert() {
        let alertController = UIAlertController(title: "Yeah!", message: "Saved the history to database: \(mom)", preferredStyle: UIAlertController.Style.alert)
        
        let actionBackHome = UIAlertAction(title: "Back to Home", style: UIAlertAction.Style.default) { action in
            self.performSegue(withIdentifier: "KlodDoneToHome", sender: self)
        }
        
        alertController.addAction(actionBackHome)
        
        present(alertController, animated: true, completion: nil)
        
        
    }
    
    func showExceptionAlert() {
        let alertController = UIAlertController(title: "ลงทะเบียนไม่สำเร็จ", message: "ข้อมูลไม่ถูกต้อง", preferredStyle: UIAlertController.Style.alert)
        
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
