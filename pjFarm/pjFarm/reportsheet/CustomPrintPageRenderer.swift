//
//  CustomPrintPageRenderer.swift
//  pjFarm
//
//  Created by Santiphop on 18/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class CustomPrintPageRenderer: UIPrintPageRenderer {
    let A4PageWidth : CGFloat = 595.2
    let A4PageHeight: CGFloat = 841.8
    
    
    override init() {
        super.init()

        let pageFrame = CGRect(x: 0.0, y: 0.0, width: A4PageWidth, height: A4PageHeight)
        self.setValue(NSValue(cgRect: pageFrame), forKey: "paperRect")
        self.setValue(NSValue(cgRect: pageFrame), forKey: "printableRect")
    }
}
