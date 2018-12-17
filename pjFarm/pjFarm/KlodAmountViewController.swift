//
//  KlodAmountViewController.swift
//  pjFarm
//
//  Created by Santiphop on 17/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class KlodAmountViewController: UIViewController {
    /*
     รหัสแม่
     พันธุ์พ่อ
     วันที่คลอด
     จำนวนลูกทั้งหมด
     จำนวนลูกที่ตาย
     พิการ
     เหลือ
     ผู้เหลือ
     เมียเหลือ
     */
    @IBOutlet weak var all: UITextField! {
        didSet {
//            all.removeCursor()
//            all?.addDoneToolbar(onDone: (target: self, action: #selector(doneButtonTappedForMomTextField)))
            all.keyboardType = UIKeyboardType.numberPad
        }
    }
    @IBOutlet weak var dead: UITextField!
    @IBOutlet weak var mummy: UITextField!
    @IBOutlet weak var left: UILabel!
    @IBOutlet weak var maleLeft: UITextField!
    @IBOutlet weak var femaleLeft: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
