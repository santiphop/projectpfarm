//
//  ReportComposer.swift
//  pjFarm
//
//  Created by Santiphop on 18/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class ReportComposer: NSObject {
    let dateFormat = DateFormatter()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let pathToReportHTMLTemplate = Bundle.main.path(forResource: "report", ofType: "html")
    var pdfFilename: String!
    
    override init() {
        super.init()
        dateFormat.dateFormat = "yyyyMMdd"
    }
    
    func renderReport(reportDate: String) -> String! {
        do {
            // Load the invoice HTML template code into a String variable.
            var HTMLContent = try String(contentsOfFile: pathToReportHTMLTemplate!)
            HTMLContent = HTMLContent.replacingOccurrences(of: "#WORK_DATE#", with: reportDate)
            
            return HTMLContent
        }
        catch {
            print("Unable to open and use HTML template files.")
        }
        
        return nil
    }
    
    func exportHTMLContentToPDF(HTMLContent: String) -> String {
        let printPageRenderer = CustomPrintPageRenderer()
        let printFormatter = UIMarkupTextPrintFormatter(markupText: HTMLContent)
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        let pdfData = drawPDFUsingPrintPageRenderer(printPageRenderer: printPageRenderer)!
        pdfFilename = "\(appDelegate.getDocumentDirectory())/Report\(dateFormat.string(from: Date()))W.pdf"
        pdfData.write(toFile: pdfFilename!, atomically: true)
        return pdfFilename
    }
    
    func drawPDFUsingPrintPageRenderer(printPageRenderer: UIPrintPageRenderer) -> NSData! {
        let data = NSMutableData()
        UIGraphicsBeginPDFContextToData(data, CGRect.zero, nil)
        UIGraphicsBeginPDFPage()
        printPageRenderer.drawPage(at: 0, in: UIGraphicsGetPDFContextBounds())
        UIGraphicsEndPDFContext()
        return data
    }
}
