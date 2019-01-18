//
//  ViewController.swift
//  pjFarm
//
//  Created by iOS Dev on 9/7/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

//  UNUSED CLASS
class HomeViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    let dateFormatForLabel = DateFormatter()
    
    @IBAction func createButton(_ sender: Any) {
        //  set up new ID
        //  prevent setup as func
        //  RegisterViewController can't get currentID if using app quickly
        ref.child("หมู/currentID").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get data
            let id = snapshot.value as? Int
            currentID = id!
            print("init currentID: \(currentID)")
            self.performSegue(withIdentifier: "createID", sender: self)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dateFormatForLabel.dateFormat = "d MMMM YYYY"
        dateLabel.text! = dateFormatForLabel.string(from: Date())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

