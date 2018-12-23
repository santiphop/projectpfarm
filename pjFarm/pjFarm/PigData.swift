//
//  PigData.swift
//  pjFarm
//
//  Created by Santiphop on 23/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class PigData: NSObject {
    var pigList = [Int]()
    var pigGiltInfo = [Int:PigMusao]()
    var pigBreederInfo = [Int:PigMaepun]()
    var pigFarrowInfo = [Int:PigKokklod]()
    var pigWeanInfo = [Int:PigKinderGarten]()

    
    func add(pig:PigMusao) {
        pigList.append(pig.id)
        pigGiltInfo[pig.id] = pig
    }
    func add(pig:PigMaepun) {
        pigList.append(pig.id)
        pigBreederInfo[pig.id] = pig
    }
    func add(pig:PigKokklod) {
        pigList.append(pig.id)
        pigFarrowInfo[pig.id] = pig
    }
    func add(pig:PigKinderGarten) {
        pigList.append(pig.id)
        pigWeanInfo[pig.id] = pig
    }
    
    
    

}
