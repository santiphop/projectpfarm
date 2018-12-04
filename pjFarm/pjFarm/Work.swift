//
//  WorkHistory.swift
//  pjFarm
//
//  Created by Santiphop on 2/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class Work: NSObject {
    var date:Date
    var ID:String
    var workName:String
    var pigID:String
    
    init(date:Date, ID:String, workName:String, pigID:String) {
        self.date = date
        self.ID = ID
        self.workName = workName
        self.pigID = pigID
    }
    
    
}
