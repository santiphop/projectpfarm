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
//    var ref:DatabaseReference
//    let dateFormat = DateFormatter()

//    var pigData = PigData()
//    var workData = WorkData()
    
    
//    var workMusao:Work
//    var workMaepun:Work
//    var workKokklod:Work
//    var workKinderg:Work
    

//    var currentID:Int = 0
    
//    
//    var pigList = [String]()
//    var pigInfo = [String:[String]]()
    
//    var currentWork:String = ""
    
//    var workList = [String]()
//    var workInfo = [String:[Int]]()
    
//    var tmrWorkIDCount:Int = 0
    
//    var primaryState:Int = 0
//    var secondaryState:Int = 0
//
    //  เฉพาะหมูสาว
//    func getAllPig() {
//        ref.child("หมู").observeSingleEvent(of: .value, with: { snapshot in
//            let data = snapshot.value as? NSDictionary
//            for (key, _) in data! {
//                if "\(key as! String)" != "currentID" {
//                    self.pigList.append("\(key as! String)")
//                }
//            }
//            print(self.pigList)
//            print(self.pigList.count)
//
//            for id in self.pigList {
//                ////////// "หมูสาว" + id + "ประวัติ"
//                let path = "หมู/\(id)/หมูสาว/ประวัติ"
//                ref.child(path).observeSingleEvent(of: .value, with: { snapshot in
//                    let data = snapshot.value as? NSDictionary
//                    let momID = data?["แม่พันธุ์"] as! String
//                    let dadBreed = data?["พ่อพันธุ์"] as! String
//                    let dateIn = data?["วันแรกเข้า"] as! String
//                    self.pigInfo[id] = []
//                    self.pigInfo[id]?.append(momID)
//                    self.pigInfo[id]?.append(dadBreed)
//                    self.pigInfo[id]?.append(dateIn)
//                })
//            }
//        })
    
    }
    
    
    
//    init() {

//        dateFormat.dateFormat = "yyyyMMdd"
//        FirebaseApp.configure()
//        ref = Database.database().reference()
        
        //  set up musao
        
        //  musao
//        workMusao = Work(
//            typeID: "1",
//            name: [
//                "ถ่ายพยาธิ", "วัคซีนอหิวาห์", "วัคซีนพาร์โว", "วัคซีนพิษสุนัขบ้าเทียม", "วัคซีนปากเท้าเทียม", "วัคซีน PRRS"
//            ],
//            addDate: [0, 7, 14, 21, 28, 32],
//            data: workData
//        )
//        
//        workMaepun = Work(
//            typeID: "2",
//            name: [
//                "ตรวจสัดครั้งที่1", "ตรวจสัดครั้งที่2", "ตรวจสัดครั้งที่3", "ตรวจท้อง", "ขึ้นคลอด", "กำหนดคลอด"
//            ],
//            addDate: [21, 42, 63, 84, 109, 114],
//            data: workData
//        )
//        
//        workKokklod = Work(
//            typeID: "3",
//            name: [
//                "ตอนตัวผู้-ตัดหูตัวเมีย", "ตัดเขี้ยวและหาง", "ถ่ายพยาธิ-กำหนดหย่านม"
//            ],
//            addDate: [3, 7, 24],
//            data: workData
//        )
//        
//        workKinderg = Work(
//            typeID: "4",
//            name: [
//                "วัคซีนอหิวาห์รอบที่1", "วัคซีนพิษสุนัขบ้าเทียมรอบที่1", "วัคซีนอหิวาห์รอบที่2", "วัคซีนพิษสุนัขบ้าเทียมรอบที่2"
//            ],
//            addDate: [7, 14, 21, 28],
//            data: workData
//        )
        
//        self.setUpCurrentID()

//    }

    //  เลื่อนงานวันนี้ไปทำพรุ่งนี้
//    func reportWorkForTomorrow(ids:[Int], bools:[Bool], date:Date) {
////        print("this\(currentWork)")
//        let todayPath = "งาน/\(dateFormat.string(from: date))W/\(currentWork)"
////        print(todayPath)
//
//        ref.child("\(todayPath)").observeSingleEvent(of: .value, with: { snapshot in
//            let data = snapshot.value as! NSDictionary
//        
//            let pigtype = data["pigtype"] as! String
//            let workstep = data["workstep"] as! Int
//            let wName = self.workData.getAt(type: pigtype).name
//            
//            for i in 0...ids.count-1 {
//                if bools[i] {
//                    //  setValue 2 is UNDONE
//                    self.ref.child("\(todayPath)/\(ids[i])").setValue(2)
//                    
//                    //  assign tomorrow
//                    self.ref.child("งาน/\(self.dateFormat.string(from: addDateComponent(date: date, intAdding: 1)))W/\(self.currentWork)/\(ids[i])").setValue(0)
//                    self.ref.child("งาน/\(self.dateFormat.string(from: addDateComponent(date: date, intAdding: 1)))W/\(self.currentWork)/pigtype").setValue(pigtype)
//                    self.ref.child("งาน/\(self.dateFormat.string(from: addDateComponent(date: date, intAdding: 1)))W/\(self.currentWork)/workstep").setValue(workstep)
//                    
//                    let wDateRemain = self.workData.getAt(type: pigtype).generateWorkDate(date: date, fromIndex: workstep + 1)
//                    let wDate2morrow = tomorrow(date: wDateRemain)
//                    
//                    
//                    for j in 0...wDateRemain.count-1 {
//                        //  remove
//                        self.ref.child("งาน/\(self.dateFormat.string(from: wDateRemain[j]))W/\(wName[workstep+j+1])/\(ids[i])").removeValue()
//                        //  assign remain
//                        self.ref.child("งาน/\(self.dateFormat.string(from: wDate2morrow[j]))W/\(wName[workstep+j+1])/\(ids[i])").setValue(0)
//                        self.ref.child("งาน/\(self.dateFormat.string(from: wDate2morrow[j]))W/\(wName[workstep+j+1])/pigtype").setValue(pigtype)
//                        self.ref.child("งาน/\(self.dateFormat.string(from: wDate2morrow[j]))W/\(wName[workstep+j+1])/workstep").setValue(workstep+j+1)
//                    }
//                }
//            }
//          
//        })
//        
//    }
    
    //  value is status of work
    //      0 = assigned
    //      1 = done
    //      2 = undone
    
//    func assignWork(id:Int, work:Work) {
//        for i in 0...(work.name.count) - 1 {
//            ref.child("งาน/\(dateFormat.string(from: work.date[i]))W/\(work.name[i])/pigtype").setValue(work.typeID)
//            ref.child("งาน/\(dateFormat.string(from: work.date[i]))W/\(work.name[i])/workstep").setValue(i)
//            ref.child("งาน/\(dateFormat.string(from: work.date[i]))W/\(work.name[i])/\(id)").setValue(0)
//            
//            if dateFormat.string(from: work.date[i]).elementsEqual(dateFormat.string(from: Date())) {
//                if !workList.contains(work.name[i]) {
//                    workList.append(work.name[i])
//                    workInfo[work.name[i]] = []
//                    workInfo[work.name[i]]?.append(id)
//                } else {
//                    workInfo[work.name[i]]?.append(id)
//                }
//            }
//        }
//    }
//    
//    func assignWork(pig:Pig) {
//        assignWork(id: pig.id, work: pig.work)
//    }
    
//    func initcheck()  {
//        print(self.workInfo)
//    }

//}

/////     รายงาน    /////
extension DatabaseManager {
//    func getAllWorkFrom(date:Date) {
//        //  append workList
//        //  append workInfo
//        let thisDate = dateFormat.string(from: date)
//        ref.child("งาน/\(thisDate)W").observeSingleEvent(of: .value, with: { snapshot in
//            let data = snapshot.value as? NSDictionary
//            
//            if data != nil {
//                for (key, _) in data! {
//                    self.workList.append(key as! String)
//                }
//            }
//
//            print(self.workList)
//            for workName in self.workList {
//                let path = "งาน/\(thisDate)W/\(workName)"
//                ref.child(path).observeSingleEvent(of: .value, with: { interSnapshot in
//                    let thisWork = interSnapshot.value as? NSDictionary
//                    self.workInfo[workName] = []
//                    for (key, _) in thisWork! {
//                        if !(key as! String).elementsEqual("pigtype") && !(key as! String).elementsEqual("workstep") {
//                            self.workInfo[workName]?.append(Int(key as! String)!)
//                        }
//                    }
//                })
//            }
//        })
//    }
    
}

/////     คอกอนุบาล  /////
extension DatabaseManager {
    
//    func regisKG(id:String, date:Date) {
//        let kindg = PigKinderGarten(id: Int(id)!, date: date, work: workKinderg)
//        pigData.add(pig: kindg)
//
//        ref.child("หมู/\(id)/สถานะ").setValue("แม่พันธุ์")
//        
//        ref.child("คอกคลอด/\(id)").observeSingleEvent(of: .value, with: { snapshot in
//            let primaryCount = snapshot.childrenCount
//            self.ref.child("คอกอนุบาล/\(id)/\(primaryCount)").setValue([
//                "เข้าคอกอนุบาล": self.dateFormat.string(from: date),
//                kindg.work.name[0]: self.dateFormat.string(from: kindg.work.date[0]),
//                kindg.work.name[1]: self.dateFormat.string(from: kindg.work.date[1]),
//                kindg.work.name[2]: self.dateFormat.string(from: kindg.work.date[2]),
//                kindg.work.name[3]: self.dateFormat.string(from: kindg.work.date[3]),
//            ])
//        })
//        
//        assignWork(pig: kindg)
//    }
}

/////     คอกคลอด   /////
extension DatabaseManager {
    //  get primary, secondary from ID
//    func getMaepunCurrentStateFrom(id:String) {
//        ref.child("แม่พันธุ์/\(id)/currentState").observeSingleEvent(of: .value, with: { snapshot in
//            let data = snapshot.value as? NSDictionary
//            if data != nil {
//                self.primaryState = data?["primary"] as! Int
//                self.secondaryState = data?["secondary"] as! Int
//            }
//        })
//    }
    
    
    
//    func regisKK(id:String, dad:String, date:Date, all:Int, dead:Int, mummy:Int, male:Int, female:Int) {
//        let remain = all-(dead+mummy)
//        
//        
//        let kokklod = PigKokklod(
//            all: all, dead: dead, mummy: mummy, remain: remain, male: male, female: female, id: Int(id)!, date: date, work: workKokklod
//        )
//        pigData.add(pig: kokklod)
//
//        
//        ref.child("หมู/\(id)/แม่พันธุ์/currentState").observeSingleEvent(of: .value, with: { snapshot in
//            let data = snapshot.value as? NSDictionary
//            let primary = data?["primary"] as! Int
//            let secondary = data?["secondary"] as! Int
//            let dateFormat = self.dateFormat
//            
//            let ref = self.ref
//            ref.child("หมู/\(id)/สถานะ").setValue("คอกคลอด")
//            ref.child("หมู/\(id)/แม่พันธุ์/\(primary)/\(secondary)/ประวัติการทำคลอด").setValue([
//                "วันคลอด":dateFormat.string(from: date),
//                "จำนวนลูกทั้งหมด":all,
//                "จำนวนลูกที่ตาย":dead,
//                "จำนวนลูกที่พิการ":mummy,
//                "จำนวนลูกที่เหลือ":remain,
//                "จำนวนลูกที่เหลือเพศผู้":male,
//                "จำนวนลูกที่เหลือเพศเมีย":female
//            ])
//            ref.child("หมู/\(id)/แม่พันธุ์/\(primary)/\(secondary)/คอกคลอด").setValue([
//                "วันคลอด":dateFormat.string(from: date),
//                "งาน":[
//                    kokklod.work.name[0]:dateFormat.string(from: kokklod.work.date[0]),
//                    kokklod.work.name[1]:dateFormat.string(from: kokklod.work.date[1]),
//                    kokklod.work.name[2]:dateFormat.string(from: kokklod.work.date[2])
//                ]
//            ])
//
//        })
//        
//        assignWork(pig: kokklod)
//    }
}

/////     แม่พันธุ์     /////
extension DatabaseManager {
    
    
//    func regisMP(date:Date, id:String) {
//        let maepun = PigMaepun(id: Int(id)!, date: date, work: workMaepun)
//        pigData.add(pig: maepun)
//
//        ref.child("หมู/\(id)/สถานะ").setValue("แม่พันธุ์")
//        ref.child("หมู/\(id)/แม่พันธุ์").setValue([
//            "currentState":[
//                "primary":1,
//                "secondary":1
//            ],
//            "\(maepun.primaryRound)":[
//                "\(maepun.secondaryRound)":[
//                    "เป็นสัดรอบแรก":dateFormat.string(from: date),
//
//                ]
//            ]
//        ])
//        for i in 0...maepun.work.name.count-1 {
//            ref.child("หมู/\(self.currentID)/แม่พันธุ์/\(maepun.primaryRound)/\(maepun.primaryRound)/งาน/\(maepun.work.name[i])").setValue(dateFormat.string(from: maepun.work.date[i]))
//        }
//        assignWork(pig: maepun)
//
//    }
}


/////     หมูสาว     /////
extension DatabaseManager {
//    func setUpCurrentID() {
//        ref.child("หมู").observeSingleEvent(of: .value, with: { snapshot in
//            // Get data
//            let data = snapshot.value as? NSDictionary
//            let id = data?["currentID"] as? Int
//            self.currentID = id!
//            print("init in observeSingleEvent, currentID: \(self.currentID)")
//        })
//    }
    
    

}
