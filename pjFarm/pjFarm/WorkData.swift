//
//  WorkData.swift
//  pjFarm
//
//  Created by Santiphop on 2/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class WorkData: NSObject {
    static let shared: WorkData = WorkData()
    var workID:[Int] = []
    
    func add(id:Int) {
        workID.append(id)
    }
    
    func getAt(index:Int) -> Int {
        return workID[index]
    }
    
}
