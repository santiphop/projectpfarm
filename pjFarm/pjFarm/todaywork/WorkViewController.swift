//
//  PreviewViewController.swift
//  pjFarm
//
//  Created by Santiphop on 3/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class WorkViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!

    let dateFormatForReportHTML = DateFormatter()
    var reportComposer: ReportComposer!
    var HTMLContent: String!
    var documentController : UIDocumentInteractionController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dateFormatForReportHTML.dateFormat = "MMM d, YYYY"
        createReportAsHTML()
    }
    
//    @IBAction func createID(_ sender: Any) {
//        //  set up new ID
//        //  prevent setup as func
//        //  RegisterViewController can't get currentID if using app quickly
//        ref.child("หมู/currentID").observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get data
//            let id = snapshot.value as? Int
//            currentID = id!
//            print("init currentID: \(currentID)")
//            self.performSegue(withIdentifier: "goRegMS", sender: self)
//        })
//    }
    
    @IBOutlet weak var exportButton: UIButton!
    @IBAction func register(_ sender: Any) {
        chooseRegisterType(message: "เลือกประเภทของการลงทะเบียน")
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
    }
    
    @IBAction func export(_ sender: Any) {
        let pdfFilename = reportComposer.exportHTMLContentToPDF(HTMLContent: self.HTMLContent)
        documentController = UIDocumentInteractionController.init(url: NSURL.init(fileURLWithPath: pdfFilename) as URL)
        documentController.presentOptionsMenu(from: self.exportButton.frame, in: self.view, animated: true)
    }
    
    func createReportAsHTML() {
        reportComposer = ReportComposer()
        if let reportHTML = reportComposer.renderReport(reportDate: dateFormatForReportHTML.string(from: Date())) {
            webView.loadHTMLString(reportHTML, baseURL: NSURL(string: reportComposer.pathToReportHTMLTemplate!)! as URL)
            HTMLContent = reportHTML
        }
    }

    @IBAction func unwindToHome(_ unwindSegue: UIStoryboardSegue) { }

}
