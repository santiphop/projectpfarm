//
//  FirstRutViewController.swift
//  pjFarm
//
//  Created by Santiphop on 4/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class FirstRutViewController: UIViewController {

    @IBOutlet weak var idTextField: UITextField! {
        didSet {
            idTextField?.addDoneToolbar(onDone: (target: self, action: #selector(doneButtonTappedIDTextField)))
            idTextField.keyboardType = UIKeyboardType.numberPad
        }
        
    }
    
    @objc func doneButtonTappedIDTextField() { idTextField.resignFirstResponder() }
    
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

