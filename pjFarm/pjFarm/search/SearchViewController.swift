//
//  ScanViewController.swift
//  pjFarm
//
//  Created by Santiphop on 30/11/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit
import AVFoundation

class SearchViewController: UIViewController {
    let captureMetadataOutput = AVCaptureMetadataOutput()

    @IBOutlet weak var idTextField: NumpadTextField!
    @IBAction func searchButton(_ sender: Any) {
        outputText = idTextField.text!
//        search()
        idTextField.text! = ""
        performSegue(withIdentifier: "QRtoSearchID", sender: self)
    }
    @IBOutlet weak var camaraView: UIView!
    
    var outputText :String!
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var isReading: Bool = false
    var isScanned :Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        startReading()
    }
    
    func startReading() -> Bool {
        // เปิดใช้งานกล้อง
        if let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                self.captureSession = AVCaptureSession()
                self.captureSession.addInput(input)
            } catch let error as NSError {
                showMessage(title: error.localizedDescription, message: error.localizedFailureReason ?? "-")
                return false
            }
            
            self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            self.videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self.videoPreviewLayer.frame = self.camaraView.layer.bounds
            self.camaraView.layer.addSublayer(self.videoPreviewLayer)
            
            self.captureSession.addOutput(captureMetadataOutput)
            captureMetadataOutput.metadataObjectTypes = captureMetadataOutput.availableMetadataObjectTypes
            
            //  get text
            self.outputText = captureMetadataOutput.availableMetadataObjectTypes.description
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            self.captureSession.startRunning()
        } else {
            showMessage(title: "ไม่สามารถเชื่อมต่อกล้องได้", message: "กรุณาอนุญาตให้ Pig's Plan เข้าถึงกล้องที่ \"การตั้งค่า\" บนอุปกรณ์ของคุณ")
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? SearchResultViewController {
            controller.id = self.outputText
        }
    }
}

extension SearchViewController:AVCaptureMetadataOutputObjectsDelegate {
    //  แปลงค่าจาก QR code
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        var qrText = ""
        
        for data in metadataObjects {
            if let qrcode = data as? AVMetadataMachineReadableCodeObject {
                qrText = qrcode.stringValue ?? "N/A" + "\n"
            }
        }
        
        // output
        self.outputText = qrText
        
        // stop scanning
        self.captureSession.stopRunning()
        self.captureSession = nil
        self.videoPreviewLayer.removeFromSuperlayer()
        self.isScanned = true
        performSegue(withIdentifier: "QRtoSearchID", sender: self)
        
    }
}
