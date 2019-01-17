//
//  ReportComposer.swift
//  pjFarm
//
//  Created by Santiphop on 18/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class ReportComposer: NSObject {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    let pathToReportHTMLTemplate = Bundle.main.path(forResource: "report", ofType: "html")
    let pathToHeadItemHTMLTemplate = Bundle.main.path(forResource: "head-id", ofType: "html")
    let pathToSingleItemHTMLTemplate = Bundle.main.path(forResource: "single-id", ofType: "html")
    let pathToLastItemHTMLTemplate = Bundle.main.path(forResource: "last-id", ofType: "html")
    
    override init() {
        super.init()
        dateFormat.dateFormat = "yyyyMMdd"
    }
    
    func renderReport(reportDate: String) -> String! {
        do {
            // Load the report HTML template code into a String variable.
            var HTMLContent = try String(contentsOfFile: pathToReportHTMLTemplate!)
            HTMLContent = HTMLContent.replacingOccurrences(of: "#WORK_DATE#", with: reportDate)
            
            // The report IDs will be added by using a loop.
            var allIDs = ""
            
            for work in workList {
                
                // For the first one we'll use the "head-id.html" template.
                // For all the items except for the first one and the last one we'll use the "single-id.html" template.
                // For the last one we'll use the "last-id.html" template.
                for i in 0...workInfo.count-1 {
                    var itemHTMLContent: String!
                    
                    // Determine the proper template file.
                    if i == 0 {
                        itemHTMLContent = try String(contentsOfFile: pathToHeadItemHTMLTemplate!)
                        itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#WORK#", with: work)
                    } else if i != workInfo.count - 1 {
                        itemHTMLContent = try String(contentsOfFile: pathToSingleItemHTMLTemplate!)
                    } else {
                        itemHTMLContent = try String(contentsOfFile: pathToLastItemHTMLTemplate!)
                    }
                    
                    // Replace the ID placeholders with the actual values.
                    itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#ID#", with: String(workInfo[work]![i]))

                    // Add the item's HTML code to the general IDs string.
                    allIDs += itemHTMLContent
                }
            }
            
            // Set the IDs.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#IDS#", with: allIDs)
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
        let pdfFilename = "\(appDelegate.getDocumentDirectory())/Report\(dateFormat.string(from: Date()))W.pdf"
        pdfData.write(toFile: pdfFilename, atomically: true)
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
