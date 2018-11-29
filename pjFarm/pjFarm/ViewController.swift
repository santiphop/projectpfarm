//
//  ViewController.swift
//  pjFarm
//
//  Created by iOS Dev on 9/7/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
//    var pig:Pig
    @IBOutlet weak var dateLabel: UILabel!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        pig = Pig(id: "1111", date: Date(timeIntervalSinceReferenceDate: 0), mother: "mom", father: "dad", gender: "chai")
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dateLabel.text = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: DateFormatter.Style.long, timeStyle: DateFormatter.Style.none)
        let db = self.appDelegate.db
        db.regisMS(dad: "LL", mom: "11", gender: "GG")
        // pdf
        
        let file = "file.txt"
        let text = "some text"
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            print(fileURL)
            do {
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
            } catch {
                
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

