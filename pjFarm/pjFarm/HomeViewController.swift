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
    let dateFormat = DateFormatter()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dateFormat.dateFormat = "d MMMM YYYY"
        dateLabel.text! = dateFormat.string(from: Date())
        let ref = Database.database().reference()
        ref.child("หมู/6122/แม่พันธุ์/currentState/primary").observeSingleEvent(of: .value, with: { snapshot in
            let data = snapshot.value as! Int
            print(data)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToHome(_ unwindSegue: UIStoryboardSegue) { }
    


}

