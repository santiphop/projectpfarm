//
//  AppDelegate.swift
//  pjFarm
//
//  Created by iOS Dev on 9/7/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var db = DatabaseManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        FirebaseApp.configure()
        
        // create variable that point to firebase's realtime_database
//        let ref = Database.database().reference()
        
        
        
        // example of read
//        ref.child("หมูสาว/1001").observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            // Get User data
//            let datas = snapshot.value as? NSDictionary
//            let dateIn = datas?["วันแรกเข้า"] as? String
//            let age = datas?["อายุ"] as? Int
//            
//            print(dateIn!)
//            print(age!)
//            })
        // example of write
//
//        ref.child("หมูสาว/1001").setValue(["วันแรกเข้า":"22-01-2018", "อายุ":1])
//        ref.child("หมูสาว/1001/วัคซีน/อหิวาห์").setValue(["วันกำหนดฉีด":"29-01-2018", "วันฉีดจริง":""])
//        ref.child("หมูสาว/1001/วัคซีน/พาร์โว").setValue(["วันกำหนดฉีด":"05-02-2018", "วันฉีดจริง":""])
//        ref.child("หมูสาว/1001/วัคซีน/พิษสุนัขบ้าเทียม").setValue(["วันกำหนดฉีด":"12-02-2018", "วันฉีดจริง":""])
//        ref.child("หมูสาว/1001/วัคซีน/ปากเท้าเทียม").setValue(["วันกำหนดฉีด":"19-02-2018", "วันฉีดจริง":""])
//        ref.child("หมูสาว/1001/วัคซีน/PRRS").setValue(["วันกำหนดฉีด":"26-02-2018", "วันฉีดจริง":""])
//        ref.child("หมูสาว/1001/วันถ่ายพยาธิ").setValue(["วันกำหนด":"", "วันถ่ายจริง":""])
//        ref.child("แม่พันธุ์/2000/2/1").setValue(["พ่อพันธุ์":"Dr", "วันที่ผสมพันธุ์":"", "จำนวนลูกทั้งหมด":"10", "จำนวนลูกที่พิการ":"1", "จำนวนลูกที่ตาย":"2", "จำนวนลูกเพศผู้ที่เหลือ":"4", "จำนวนลูกเพศเมียที่เหลือ":"3", "จำนวนลูกที่เหลือทั้งหมด":"7", "วันเป็นสัดรอบแรก":"01-06-2018"])
//        ref.child("แม่พันธุ์/2000/1/1/วันตรวจสัดครั้งที่1").setValue(["วันกำหนด":"22-06-2018", "วันจริง":nil])
//        ref.child("แม่พันธุ์/2000/1/1/วันตรวจสัดครั้งที่2").setValue(["วันกำหนด":"13-07-2018", "วันจริง":""])
//        ref.child("แม่พันธุ์/2000/1/1/วันตรวจสัดครั้งที่3").setValue(["วันกำหนด":"03-08-2018", "วันจริง":""])
//        ref.child("แม่พันธุ์/2000/1/1/วันตรวจท้อง").setValue(["วันกำหนด":"24-08-2018", "วันจริง":""])
//        ref.child("แม่พันธุ์/2000/1/1/วันขึ้นคลอด").setValue(["วันกำหนด":"17-09-2018", "วันจริง":""])
//        ref.child("แม่พันธุ์/2000/1/1/วันคลอด").setValue(["วันกำหนด":"22-09-2018", "วันจริง":""])
//        
//        
//        ref.child("คอกลูกหมู/2000/1/5").setValue(["วันคลอด":"22-09-2018"])
//        ref.child("คอกลูกหมู/2000/1/5/วันตัดเขี้ยวและหาง").setValue(["วันกำหนด":"25-09-2018", "วันจริง":""])
//        ref.child("คอกลูกหมู/2000/1/5/วันตอนตัวผู้").setValue(["วันกำหนด":"29-09-2018", "วันจริง":""])
//        ref.child("คอกลูกหมู/2000/1/5/วันตัดหูตัวเมียที่จะเป็นแม่พันธุ์").setValue(["วันกำหนด":"29-09-2018", "วันจริง":""])
//        ref.child("คอกลูกหมู/2000/1/5/วันหย่านม").setValue(["วันกำหนด":"16-10-2018", "วันจริง":""])
//        ref.child("คอกลูกหมู/2000/1/5/วันถ่ายพยาธิ").setValue(["วันกำหนด":"16-10-2018", "วันจริง":""])
//        
//        
//        ref.child("คอกอนุบาล/2000/1/3").setValue(["จำนวนตัว":7, "วันเข้าคอกอนุบาล":"24-10-2018"])
//        ref.child("คอกอนุบาล/2000/1/3/วันฉีดวัคซีนอหิวาห์รอบที่1").setValue(["วันกำหนด":"31-10-2018", "วันจริง":""])
//        ref.child("คอกอนุบาล/2000/1/3/วันฉีดวัคซีนพิษสุนัขบ้าเทียมรอบที่1").setValue(["วันกำหนด":"7-11-2018", "วันจริง":""])
//        ref.child("คอกอนุบาล/2000/1/3/วันฉีดวัคซีนอหิวาห์รอบที่2").setValue(["วันกำหนด":"14-11-2018", "วันจริง":""])
//        ref.child("คอกอนุบาล/2000/1/3/วันฉีดวัคซีนพิษสุนัขบ้าเทียมรอบที่2").setValue(["วันกำหนด":"21-11-2018", "วันจริง":""])
//        ref.child("งาน/22-07-2018").setValue(["เสร็จ":["1":"1222"],"ไม่เสร็จ":["1":"4444"]])

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


}

