//
//  AppDelegate.swift
//  pjFarm
//
//  Created by iOS Dev on 9/7/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

var ref = Database.database().reference()
let dateFormat = DateFormatter()
let dateFormatForTextField = DateFormatter()


var currentWork = String()
var currentID = Int()

var workList = [String]()
var workInfo = [String:[Int]]()

var workData = WorkData()
let workMusao = Work(
    typeID: "1",
    name: [
        "ถ่ายพยาธิ", "วัคซีนอหิวาห์", "วัคซีนพาร์โว", "วัคซีนพิษสุนัขบ้าเทียม", "วัคซีนปากเท้าเทียม", "วัคซีน PRRS"
    ],
    addDate: [0, 7, 14, 21, 28, 32],
    data: workData
)
let workMaepun = Work(
    typeID: "2",
    name: [
        "ตรวจสัดครั้งที่1", "ตรวจสัดครั้งที่2", "ตรวจสัดครั้งที่3", "ตรวจท้อง", "ขึ้นคลอด", "กำหนดคลอด"
    ],
    addDate: [21, 42, 63, 84, 109, 114],
    data: workData
)
let workKokklod = Work(
    typeID: "3",
    name: [
        "ตอนตัวผู้-ตัดหูตัวเมีย", "ตัดเขี้ยวและหาง", "ถ่ายพยาธิ-กำหนดหย่านม"
    ],
    addDate: [3, 7, 24],
    data: workData
)
let workKinderg = Work(
    typeID: "4",
    name: [
        "วัคซีนอหิวาห์รอบที่1", "วัคซีนพิษสุนัขบ้าเทียมรอบที่1", "วัคซีนอหิวาห์รอบที่2", "วัคซีนพิษสุนัขบ้าเทียมรอบที่2"
    ],
    addDate: [7, 14, 21, 28],
    data: workData
)

let dadArray = ["Large White", "Duroc", "Landrace"]


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let db = DatabaseManager()
    let pigData = PigData()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        dateFormat.dateFormat = "yyyyMMdd"
        dateFormatForTextField.dateFormat = "MMMM d, yyyy"

        setUpCurrentID()

        getAllWorkFrom(date: Date())
//        db.getAllPig()
//        let ref = Database.database().reference()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: Custom Methods
    
    func getDocumentDirectory() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
    

}

//  global

func tomorrow(date:[Date]) -> [Date] {
    var tmp = [Date]()
    for d in date {
        tmp.append(tomorrow(date: d))
    }
    return tmp
}

func tomorrow(date:Date) -> Date {
    return addDateComponent(date: date, intAdding: 1)
}

func addDateComponent(date:Date, intAdding:Int) -> Date {
    var dateComponent = DateComponents()
    dateComponent.day = intAdding
    let newDate = Calendar.current.date(byAdding: dateComponent, to: date)!
    return newDate
}

func setUpCurrentID() {
    ref.child("หมู/currentID").observeSingleEvent(of: .value, with: { snapshot in
        // Get data
        let id = snapshot.value as? Int
        currentID = id!
        print("init currentID: \(currentID)")
    })
}

func assignWork(id:Int, work:Work) {
    for i in 0...(work.name.count) - 1 {
        ref.child("งาน/\(dateFormat.string(from: work.date[i]))W/\(work.name[i])/pigtype").setValue(work.typeID)
        ref.child("งาน/\(dateFormat.string(from: work.date[i]))W/\(work.name[i])/workstep").setValue(i)
        ref.child("งาน/\(dateFormat.string(from: work.date[i]))W/\(work.name[i])/\(id)").setValue(0)
//        
//        if dateFormat.string(from: work.date[i]).elementsEqual(dateFormat.string(from: Date())) {
//            if !workList.contains(work.name[i]) {
//                workList.append(work.name[i])
//                workInfo[work.name[i]] = []
//                workInfo[work.name[i]]?.append(id)
//            } else {
//                workInfo[work.name[i]]?.append(id)
//            }
//        }
    }
}

//func assignWork(pig:Pig) {
//    assignWork(id: pig.id, work: pig.work)
//}

func reportWorkForTomorrow(ids:[Int], bools:[Bool], date:Date) {
    //        print("this\(currentWork)")
    let todayPath = "งาน/\(dateFormat.string(from: date))W/\(currentWork)"
    //        print(todayPath)
    
    ref.child("\(todayPath)").observeSingleEvent(of: .value, with: { snapshot in
        let data = snapshot.value as! NSDictionary
        
        let pigtype = data["pigtype"] as! String
        let workstep = data["workstep"] as! Int
        let wName = workData.getAt(type: pigtype).name
        
        for i in 0...ids.count-1 {
            if bools[i] {
                //  setValue 2 is UNDONE
                ref.child("\(todayPath)/\(ids[i])").setValue(2)
                
                //  assign tomorrow
                ref.child("งาน/\(dateFormat.string(from: addDateComponent(date: date, intAdding: 1)))W/\(currentWork)/\(ids[i])").setValue(0)
                ref.child("งาน/\(dateFormat.string(from: addDateComponent(date: date, intAdding: 1)))W/\(currentWork)/pigtype").setValue(pigtype)
                ref.child("งาน/\(dateFormat.string(from: addDateComponent(date: date, intAdding: 1)))W/\(currentWork)/workstep").setValue(workstep)
                
                let wDateRemain = workData.getAt(type: pigtype).generateWorkDate(date: date, fromIndex: workstep + 1)
                let wDate2morrow = tomorrow(date: wDateRemain)
                
                
                for j in 0...wDateRemain.count-1 {
                    //  remove
                    ref.child("งาน/\(dateFormat.string(from: wDateRemain[j]))W/\(wName[workstep+j+1])/\(ids[i])").removeValue()
                    //  assign remain
                    ref.child("งาน/\(dateFormat.string(from: wDate2morrow[j]))W/\(wName[workstep+j+1])/\(ids[i])").setValue(0)
                    ref.child("งาน/\(dateFormat.string(from: wDate2morrow[j]))W/\(wName[workstep+j+1])/pigtype").setValue(pigtype)
                    ref.child("งาน/\(dateFormat.string(from: wDate2morrow[j]))W/\(wName[workstep+j+1])/workstep").setValue(workstep+j+1)
                }
            }
        }
        
    })
    
}

func getAllWorkFrom(date:Date) {
    //  append workList
    //  append workInfo
    let thisDate = dateFormat.string(from: date)
    ref.child("งาน/\(thisDate)W").observeSingleEvent(of: .value, with: { snapshot in
        let data = snapshot.value as? NSDictionary
        
        if data != nil {
            for (key, _) in data! {
                workList.append(key as! String)
            }
        }
        
        print(workList)
        for workName in workList {
            let path = "งาน/\(thisDate)W/\(workName)"
            ref.child(path).observeSingleEvent(of: .value, with: { interSnapshot in
                let thisWork = interSnapshot.value as? NSDictionary
                workInfo[workName] = []
                for (key, _) in thisWork! {
                    if !(key as! String).elementsEqual("pigtype") && !(key as! String).elementsEqual("workstep") {
                        workInfo[workName]?.append(Int(key as! String)!)
                    }
                }
            })
        }
    })
}

func regisMP(date:Date, id:String, primary:Int, secondary:Int) {
    ref.child("หมู/\(id)/สถานะ").setValue("แม่พันธุ์")
    ref.child("หมู/\(id)/แม่พันธุ์").setValue([
        "currentState":[
            "primary":primary,
            "secondary":1
        ],
        "\(primary)":[
            "\(secondary)":[
                "เป็นสัดรอบแรก":dateFormat.string(from: date),
            ]
        ]
        ])
    for i in 0...workMaepun.name.count-1 {
        ref.child("หมู/\(currentID)/แม่พันธุ์/\(primary)/\(secondary)/งาน/\(workMaepun.name[i])").setValue(dateFormat.string(from: workMaepun.date[i]))
    }
    assignWork(id: Int(id)!, work: workMaepun)
}


