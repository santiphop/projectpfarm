//
//  PigData.swift
//  pjFarm
//
//  Created by Santiphop on 10/10/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class PigData: NSObject {

    var pigData:[PigMusao]
    
    override init() {
        pigData = []
    }
    
    func add(pig:PigMusao) {
        pigData.append(pig)
    }
    
    func getAt(index:Int) -> PigMusao {
        return pigData[index]
    }
    
    func delete(index:Int) -> PigMusao {
        return pigData.remove(at: index)
    }
    
}
