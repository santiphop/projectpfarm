//
//  PreviewViewController.swift
//  pjFarm
//
//  Created by Santiphop on 3/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class WorkViewController: UIViewController {
    
    
    

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var registerButton: RoundButton!
    @IBOutlet weak var reportButton: RoundButton!
    
    @IBOutlet weak var webView: UIWebView!

    let dateFormatForReportHTML = DateFormatter()
    var reportComposer: ReportComposer!
    var HTMLContent: String!
    var documentController: UIDocumentInteractionController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        disableShareButton()
        
        dateFormatForReportHTML.dateFormat = "MMM d, YYYY"
        
        workList.removeAll()
        workInfo.removeAll()
        
        //  append workList
        //  append workInfo
        let date = dateFormat.string(from: Date())
        ref.child("งาน/\(date)W").observeSingleEvent(of: .value) { (snapshot) in
            if let today = snapshot.value as? NSDictionary {
                for (work, ids) in today {
                    workInfo[work as! String] = []
                    for (id, status) in (ids as? NSDictionary)! {
                        //  intID = no pigtype and workstep
                        //  status 0 = ASSIGNED
                        //  status 1 = DONE
                        //  status 2 = UNDONE
                        if let intID = Int(id as! String), (status as! Int) == 0 {
                            workInfo[work as! String]?.append(intID)
                        }
                    }
                    
                    if !(workInfo[work as! String]?.isEmpty)! {
                        workList.append(work as! String)
                        workInfo[work as! String]?.sort()
                    } else {
                        workInfo.removeValue(forKey: work as! String)
                    }
                }
                self.createReportAsHTML()
            }
        }
        
    }
    
    // continue from viewDidLoad()
    func createReportAsHTML() {
        reportComposer = ReportComposer()
        if let reportHTML = reportComposer.renderReport(reportDate: dateFormatForReportHTML.string(from: Date())) {
            webView.loadHTMLString(reportHTML, baseURL: NSURL(string: reportComposer.pathToReportHTMLTemplate!)! as URL)
            HTMLContent = reportHTML
            shareButton.isEnabled = true
        }
    }
    
    
    @IBAction func goSearch(_ sender: Any) {
        searchButton.isEnabled = false
        pigs["ทั้งหมด"] = []
        ref.child("หมู").observeSingleEvent(of: .value) { (snapshot) in
            if let allpig = snapshot.value as? NSDictionary {
                for (id, _) in allpig {
                    if Int(id as! String) != nil {
                        pigs["ทั้งหมด"]?.append(id as! String)
                    }
                }
                pigs["ทั้งหมด"]?.sort()
                self.performSegue(withIdentifier: "goSearch", sender: self)
                self.searchButton.isEnabled = true
            }
        }
    }
    
    /*
     
     // Share Button
     
     */
    
    @IBOutlet weak var exportButton: UIButton!
    
    @IBAction func export(_ sender: Any) {
        let pdfFilename = reportComposer.exportHTMLContentToPDF(HTMLContent: self.HTMLContent)
        documentController = UIDocumentInteractionController.init(url: NSURL.init(fileURLWithPath: pdfFilename) as URL)
        documentController.presentOptionsMenu(from: self.exportButton.frame, in: self.view, animated: true)
    }
    
    func disableShareButton() {
        shareButton.isEnabled = false
    }
    
    /*
     
     // Register Button
     
     */
    
    @IBAction func goRegister(_ sender: Any) {
        registerButton.isEnabled = false
        getAllPig()
    }
    
    func getAllPig() {
        pigs["หมูสาว"] = []
        pigs["แม่พันธุ์"] = []
        pigs["คอกคลอด"] = []
        pigs["คอกอนุบาล"] = []
        ref.child("หมู").observeSingleEvent(of: .value) { (snapshot) in
            if let allpig = snapshot.value as? NSDictionary {
                for (id, data) in allpig {
                    if Int(id as! String) != nil {
                        let status = (data as! NSDictionary)["สถานะ"] as! String
                        pigs[status]?.append(id as! String)
                        if status.elementsEqual("แม่พันธุ์") {
                            let maepunData = (data as! NSDictionary).value(forKey: "แม่พันธุ์") as! NSDictionary
                            if (maepunData.value(forKey: "จำนวนลูกหมูเพศเมีย") as? Int) != nil {
                                pigs["คอกอนุบาล"]?.append(id as! String)
                            }
                        }
                    }
                }
                pigs["หมูสาว"]?.sort()
                pigs["แม่พันธุ์"]?.sort()
                pigs["คอกคลอด"]?.sort()
                pigs["คอกอนุบาล"]?.sort()
                self.chooseRegisterType(message: "เลือกประเภทของการลงทะเบียน")
            }
        }
    }
    
    func chooseRegisterType(message:String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.actionSheet)
        
        alertController.addAction(
            UIAlertAction(title: "หมูสาว", style: UIAlertAction.Style.default) { action in
                ref.child("หมู/currentID").observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get data
                    let id = snapshot.value as? Int
                    currentID = id!
                    print("init currentID: \(currentID)")
                    self.performSegue(withIdentifier: "goRegMS", sender: self)
                })
        })
        alertController.addAction(
            UIAlertAction(title: "แม่พันธุ์", style: UIAlertAction.Style.default) { action in
                self.performSegue(withIdentifier: "goRegMP", sender: self)
        })
        alertController.addAction(
            UIAlertAction(title: "คอกคลอด", style: UIAlertAction.Style.default) { action in
                self.performSegue(withIdentifier: "goRegKK", sender: self)
        })
        alertController.addAction(
            UIAlertAction(title: "คอกอนุบาล", style: UIAlertAction.Style.default) { action in
                self.performSegue(withIdentifier: "goRegKG", sender: self)
        })
        alertController.addAction(UIAlertAction(title: "ยกเลิก", style: UIAlertAction.Style.cancel))
        self.present(alertController, animated: true)
        registerButton.isEnabled = true
    }
    
    /*
     
     // Report Button
     
     */
    
    @IBAction func goReport(_ sender: Any) {
        reportButton.isEnabled = false
        getAllWorkFrom(dateFormat: dateFormat.string(from: Date()))
    }
    
    func getAllWorkFrom(dateFormat:String) {
        workList.removeAll()
        workInfo.removeAll()
        
        //  append workList
        //  append workInfo
        ref.child("งาน/\(dateFormat)W").observeSingleEvent(of: .value) { (snapshot) in
            if let today = snapshot.value as? NSDictionary {
                for (work, ids) in today {
                    workInfo[work as! String] = []
                    for (id, status) in (ids as? NSDictionary)! {
                        //  intID = no pigtype and workstep
                        //  status 0 = ASSIGNED
                        //  status 1 = DONE
                        //  status 2 = UNDONE
                        if let intID = Int(id as! String), (status as! Int) == 0 {
                            workInfo[work as! String]?.append(intID)
                        }
                    }
                    
                    if !(workInfo[work as! String]?.isEmpty)! {
                        workList.append(work as! String)
                        workInfo[work as! String]?.sort()
                    } else {
                        workInfo.removeValue(forKey: work as! String)
                    }
                }
                self.performSegue(withIdentifier: "goReport", sender: self)
                self.reportButton.isEnabled = true
            }
        }
    }
    
    @IBAction func unwindToHome(_ unwindSegue: UIStoryboardSegue) { }

}
