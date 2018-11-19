//
//  PigData.swift
//  pjFarm
//
//  Created by Santiphop on 10/10/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class PigData: NSObject {

    var pigData:[Pig]
    
    override init() {
        pigData = []
    }
    
    func add(pig:Pig) {
        pigData.append(pig)
    }
    
    func getAt(index:Int) -> Pig {
        return pigData[index]
    }
    
    func delete(index:Int) -> Pig {
        return pigData.remove(at: index)
    }
    
}
