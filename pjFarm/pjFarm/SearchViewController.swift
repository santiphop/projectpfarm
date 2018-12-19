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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func startReading() -> Bool {
        if let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                self.captureSession = AVCaptureSession()
                self.captureSession.addInput(input)
            } catch let error as NSError {
                showMessage(msgTitle: error.localizedDescription, msgText: error.localizedFailureReason ?? "-")
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
            showMessage(msgTitle: "Cannot Access Camera", msgText: "Please Allow the App to access your camera")
        }
        return true
    }
    
    func showMessage(msgTitle:String, msgText:String) {
        let alert = UIAlertController(title: msgTitle, message: msgText, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! SearchByIDViewController
        if isScanned {
            controller.id = self.outputText
            controller.autoSearch = true
        }
    }
}

extension SearchViewController:AVCaptureMetadataOutputObjectsDelegate {
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
