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
    
    @IBOutlet weak var exportButton: UIButton!
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

}
