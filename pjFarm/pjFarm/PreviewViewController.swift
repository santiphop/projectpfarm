//
//  PreviewViewController.swift
//  pjFarm
//
//  Created by Santiphop on 3/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {

    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let db = appDelegate.db
//        db.println()
    }
    
    
    // เป็นสัดครั้งแรก ใส่ ID หมูที่เป็นสัด
    @IBAction func firstRut(_ sender: Any) {

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
