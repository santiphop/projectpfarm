//
//  ViewController.swift
//  pjFarm
//
//  Created by iOS Dev on 9/7/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
//    var pig:Pig
    @IBOutlet weak var dateLabel: UILabel!
    var dateFormat = DateFormatter()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        pig = Pig(id: "1111", date: Date(timeIntervalSinceReferenceDate: 0), mother: "mom", father: "dad", gender: "chai")
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dateFormat.dateFormat = "d MMMM YYYY"
        dateLabel.text! = dateFormat.string(from: Date())
//        dateLabel.text = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: DateFormatter.Style.long, timeStyle: DateFormatter.Style.none)
//        let db = self.appDelegate.db
//        db.regisMS(dad: "LL", mom: "11", gender: "GG")
        
        let db = appDelegate.db
        
        db.get1912work()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToHome(_ unwindSegue: UIStoryboardSegue) { }
    


}

