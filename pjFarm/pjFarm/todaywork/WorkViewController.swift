//
//  PreviewViewController.swift
//  pjFarm
//
//  Created by Santiphop on 3/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class WorkViewController: UIViewController {

    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    let dateFormatForReportHTML = DateFormatter()
    var reportComposer: ReportComposer!
    var HTMLContent: String!
    
    var documentController : UIDocumentInteractionController!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dateFormatForReportHTML.dateFormat = "MMM d, YYYY"
        let db = appDelegate.db
        db.initcheck()
        createReportAsHTML()
    }
    
    @IBOutlet weak var exportButton: UIButton!
    @IBAction func export(_ sender: Any) {
        let pdfFilename = reportComposer.exportHTMLContentToPDF(HTMLContent: self.HTMLContent)
        documentController = UIDocumentInteractionController.init(url: NSURL.init(fileURLWithPath: pdfFilename) as URL)
        documentController.presentOptionsMenu(from: self.exportButton.frame, in: self.view, animated: true)
    }
    @IBOutlet weak var webView: UIWebView!
    
    func createReportAsHTML() {
        reportComposer = ReportComposer()
        if let invoiceHTML = reportComposer.renderReport(reportDate: dateFormatForReportHTML.string(from: Date())) {
            
            webView.loadHTMLString(invoiceHTML, baseURL: NSURL(string: reportComposer.pathToInvoiceHTMLTemplate!)! as URL)
            HTMLContent = invoiceHTML
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
