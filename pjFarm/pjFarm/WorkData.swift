//
//  WorkData.swift
//  pjFarm
//
//  Created by Santiphop on 2/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class WorkData: NSObject {
    var works = [String:Work]()

    func add(work:Work) {
        works[work.typeID] = work
    }
    
    func getAt(type:String) -> Work {
        return works[type]!
    }
    
}

