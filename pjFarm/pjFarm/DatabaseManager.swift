//
//  DatabaseManager.swift
//  pjFarm
//
//  Created by Santiphop on 28/11/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DatabaseManager {
    var ref : DatabaseReference
    var currentIDMS : Int = 0
    
    init() {
        FirebaseApp.configure()
        ref = Database.database().reference()
        ref.child("หมูสาว").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get currentID
            let datas = snapshot.value as? NSDictionary
            self.currentIDMS = datas?["currentID"] as! Int
            
        })
    }
    
    func regisMS(dad:String, mom:String, gender:String) {
        
        print(self.currentIDMS)
        let newID = String(currentIDMS + 1)
        ref.child("หมูสาว/"+newID).setValue(["แม่พันธุ์":mom, "พ่อพันธุ์":dad,"เพศ":gender])
        ref.child("หมูสาว/currentID").setValue(Int(newID))
        self.currentIDMS = (Int(newID))!
    }
}
