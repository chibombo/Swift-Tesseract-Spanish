//
//  ViewController.swift
//  visionTesseract
//
//  Created by HP501865 on 02/03/18.
//  Copyright © 2018 HP501865. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    let captureSession = AVCaptureSession()
    var previewLayer:CALayer!
    
    var captureDevice:AVCaptureDevice!
    
    @objc var takePhoto = false
    var isIpad:Bool = false
    static var isReverso:Bool = false
    static var count: Int = 0
    static var countReverso:Int = 0
    static var isCorrect1:Bool = true
    static var isCorrect2:Bool = true
    let screenSize = UIScreen.main.bounds.size
    public static var imgCredencial: UIImageView!
    public static var lblFoto: UILabel!
    var btnCapturar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        prepareCamera()
        ViewController.imgCredencial = UIImageView(frame: CGRect(x: screenSize.width/2 - (isIpad ? (screenSize.width * 0.75)/2:(screenSize.width * 0.95)/2),
                                                                 y: screenSize.height/2 - (screenSize.height * 0.35)/2,
                                                                 width: isIpad ?  screenSize.width * 0.75:screenSize.width * 0.95,
                                                                 height: screenSize.height * 0.35))
        ViewController.imgCredencial.layer.borderWidth = 3
        ViewController.imgCredencial.layer.cornerRadius = 5
        ViewController.imgCredencial.layer.borderColor = UIColor.white.cgColor
        self.view.addSubview(ViewController.imgCredencial)
        
        ViewController.lblFoto = UILabel(frame: CGRect(x:screenSize.width * 0.5 - (screenSize.width * 0.8)/2,
                                                       y:0,
                                                       width:screenSize.width * 0.8,
                                                       height: screenSize.height * 0.5))
        if ViewController.isReverso == false{
            ViewController.lblFoto.text = "Tome la foto del anverso de la credencial"
        }else if ViewController.isReverso == true {
            
            ViewController.lblFoto.text = "Tome la foto del reverso de la credencial"
        }
        
        ViewController.lblFoto.font = UIFont.boldSystemFont(ofSize: 25)
        ViewController.lblFoto.numberOfLines = 0
        ViewController.lblFoto.textColor = UIColor.white
        ViewController.lblFoto.textAlignment = .center
        self.view.addSubview(ViewController.lblFoto)
        
        btnCapturar = UIButton(frame: CGRect(x:screenSize.width/2 - (screenSize.width * 0.17)/2,
                                             y:screenSize.height * 0.89,
                                             width: screenSize.width * 0.17,
                                             height:screenSize.width * 0.17))
        btnCapturar.backgroundColor = UIColor.white
        btnCapturar.layer.cornerRadius = btnCapturar.frame.height/2
        btnCapturar.addTarget(self, action: #selector(takesPhoto), for: .touchUpInside)
        btnCapturar.setTitleColor(UIColor.blue, for: .normal)
        self.view.addSubview(btnCapturar)
        
        if ViewController.isCorrect1 == false{
            let errorAlert:UIAlertController = UIAlertController(title: "Error", message: "Tome una foto del anverso de una credencial", preferredStyle: UIAlertControllerStyle.alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(errorAlert, animated: true, completion: nil)
        }
        if ViewController.isCorrect2 == false{
            let errorAlert:UIAlertController = UIAlertController(title: "Error", message: "Tome una foto del reverso de una credencial", preferredStyle: UIAlertControllerStyle.alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(errorAlert, animated: true, completion: nil)
        }
    }
    
    func prepareCamera() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices
        captureDevice = availableDevices.first
        beginSession()
        
        
    }
    
    func beginSession () {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession.addInput(captureDeviceInput)
            
        }catch {
            print(error.localizedDescription)
        }
        
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer = previewLayer
        self.view.layer.addSublayer(self.previewLayer)
        self.previewLayer.frame = self.view.layer.frame
        captureSession.startRunning()
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [((kCVPixelBufferPixelFormatTypeKey as NSString) as String):NSNumber(value:kCVPixelFormatType_32BGRA)]
        
        dataOutput.alwaysDiscardsLateVideoFrames = true
        
        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
        }
        
        captureSession.commitConfiguration()
        
        let queue = DispatchQueue(label: "com.profuturo.captureQueue")
        dataOutput.setSampleBufferDelegate(self, queue: queue)
        
    }
    
    @objc func takesPhoto() {
        takePhoto = true
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection)  {
        
        if takePhoto {
            takePhoto = false
            
            if let image = self.getImageFromSampleBuffer(buffer: sampleBuffer) {
                let photoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoVC") as! PhotoViewController
                photoVC.takenPhoto = image
                DispatchQueue.main.async {
                    self.present(photoVC, animated: true, completion: {
                        self.stopCaptureSession()
                    })
                }
            }
        }
    }
    
    
    func getImageFromSampleBuffer (buffer:CMSampleBuffer) -> UIImage? {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) {
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let context = CIContext()
            
            let imageRect = CGRect(x: isIpad ? 450:280, y:isIpad ? 170:40, width:isIpad ? 950:450, height: isIpad ? 1600:650)
            
            if let image = context.createCGImage(ciImage, from: imageRect) {
                return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
            }
        }
        return nil
    }
    
    
    func stopCaptureSession () {
        self.captureSession.stopRunning()
        
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                self.captureSession.removeInput(input)
            }
        }
    }
}
