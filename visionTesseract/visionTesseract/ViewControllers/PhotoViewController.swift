//
//  PhotoViewController.swift
//  visionTesseract
//
//  Created by HP501865 on 02/03/18.
//  Copyright © 2018 HP501865. All rights reserved.
//

import UIKit
import TesseractOCR
import Vision
import AVFoundation

class PhotoViewController: UIViewController {
    
    var takenPhoto:UIImage?
    var isIpad = false
    let screenSize = UIScreen.main.bounds.size
    var requests: [VNRequest] = [VNRequest]()        
    var imageCropped: UIImageView!
    var imageOne: UIImage!
    var count: Int8 = 1

     var arrWords = [String]()
    var c = 0
    
    
    var name = String()
    var apPaterno =  String()
    var apMaterno = String()
    var dir =  String()
    var claveElector = String()
    var curp = String()
    var estado = String()
    var localidad = String()
    var municipio = String()
    var emision = String()
    var seccion = String()
    var vigencia = String()
    var anioRegistro = String()
    var sexo = String()
    var fechaNacimiento = String()
    var folio = String()
    
    var btnNext: UIButton!
    var btnBack:UIButton!
    var imageView: UIImageView!

    @IBOutlet weak var tfData: UITextView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        btnBack = UIButton(frame:CGRect(x:10,
                                        y: screenSize.height * 0.01,
                                        width:screenSize.width * 0.1,
                                        height:screenSize.height * 0.1 ))
        btnBack.setTitle("Atras", for: .normal)
        btnBack.setTitleColor(UIColor.blue, for: .normal)
        btnBack.addTarget(self, action: #selector(goBack) , for: .touchUpInside)
        self.view.addSubview(btnBack)
        
        btnNext = UIButton(frame:CGRect(x:screenSize.width * 0.8,
                                        y: btnBack.frame.origin.y,
                                        width:screenSize.width * 0.2,
                                        height:screenSize.height * 0.1 ))
        btnNext.setTitle("Siguiente", for: .normal)
        btnNext.setTitleColor(UIColor.blue, for: .normal)
        btnNext.addTarget(self, action: #selector(goNext) , for: .touchUpInside)
        self.view.addSubview(btnNext)
        
        imageView = UIImageView(frame:CGRect(x: isIpad ? screenSize.width/2 - (screenSize.width * 0.8)/2:16,
                                             y:isIpad ?  screenSize.height * 0.15:58,
                                             width:isIpad ? screenSize.width * 0.8 :343,
                                             height:isIpad ? screenSize.height * 0.4:100))
        self.view.addSubview(imageView)
        
        imageCropped = UIImageView.init(frame: CGRect(x: 10, y: 450, width:imageView.frame.width, height: imageView.frame.height))
        if let availableImage = takenPhoto?.scaleImage(1080) {
            
           
            imageView.image = availableImage

            imageView.contentMode = .scaleToFill
            if ViewController.isReverso == false{
                analyze()
                
                switch ViewController.count {
                case 0:
                    print("Tome una foto del anverso de una credencial")


                    self.dismiss(animated: true, completion: nil)


                case 1:
                    print("Es IFE")
                    startTextDetection()
                    
                    self.performImageRecognition(self.cropImageFrontLeftName(screenshot: (takenPhoto!.scaleImage(1080)?.g8_blackAndWhite())!))
                    
                    self.imageView.image = availableImage
                    self.delayExecutionByMilliseconds(500) {
                        self.startTextDetection()
                        self.performImageRecognition(self.cropImageFrontLeftDir(screenshot: (self.takenPhoto!.scaleImage(1080)?.g8_blackAndWhite())!))
                        
                        self.imageView.image = availableImage
                        self.delayExecutionByMilliseconds(500) {
                            self.startTextDetection()
                            self.performImageRecognition(self.cropImageFrontLeftFolRegEleCurp(screenshot: (self.takenPhoto!.scaleImage(1080)?.g8_blackAndWhite())!))
                            
                            self.imageView.image = availableImage
                            self.delayExecutionByMilliseconds(1000) {
                                self.startTextDetection()

                                self.performImageRecognition(self.cropImageFrontLeftOtherData(screenshot: (self.takenPhoto!.scaleImage(1080)?.g8_blackAndWhite())!))

                                self.imageView.image = availableImage
                                self.delayExecutionByMilliseconds(1000) {
                                    self.startTextDetection()

                                    self.performImageRecognition(self.cropImageFrontLeftOtherData2(screenshot: (self.takenPhoto!.scaleImage(1080)?.g8_blackAndWhite())!))

                                    self.delayExecutionByMilliseconds(100) {
                                        self.showData2()
                                    }
                                }
                            }
                        }
                    }
                    
                case 2:
                    print("Es INE")
                    
                    
                    startTextDetection()
                    self.performImageRecognition(self.cropImageFrontRightName(screenshot: (imageView.image!.scaleImage(1080)?.g8_blackAndWhite())!))
                    imageView.image = availableImage
                
                    self.delayExecutionByMilliseconds(1000) {

                        
                        self.startTextDetection()
                        self.performImageRecognition(self.cropImageFrontRightDir(screenshot: (self.imageView.image!.scaleImage(1080)?.g8_blackAndWhite())!))
                        
                        self.imageView.image = availableImage
                        self.delayExecutionByMilliseconds(1000) {
                            self.startTextDetection()
                            self.performImageRecognition(self.cropImageFrontRightEdoLoc(screenshot: (self.imageView.image!.scaleImage(1080)?.g8_blackAndWhite())!))

                            self.imageView.image = availableImage
                            self.delayExecutionByMilliseconds(1000) {
                                self.startTextDetection()
                                self.performImageRecognition(self.cropImageFrontRightMunEmi(screenshot: (self.imageView.image!.scaleImage(1080)?.g8_blackAndWhite())!))
                                

                                self.imageView.image = availableImage
                                self.delayExecutionByMilliseconds(1000) {
                                    self.startTextDetection()
                                    self.performImageRecognition(self.cropImageFrontRightRegSecVig(screenshot: (self.imageView.image!.scaleImage(1080)?.g8_blackAndWhite())!))
                                    
                                    
                                    self.delayExecutionByMilliseconds(100) {
                                        self.showData()
                                    }
                                    
                                }

                            }
                        }
                        
                      
                    }

                default:
                    break
                }

            }else if ViewController.isReverso == true {
                btnNext.removeFromSuperview()
                analyze()
                
                if ViewController.countReverso == 0{
                    switch ViewController.count {
                    case 1:
                        print("Es IFE reverso")
                    case 2:
                        print("Es INE reverso")
                    default:
                        break
                    }
                    
                }else{
                    print("tome la foto del reverso de la credencial")
                    self.dismiss(animated: true, completion: nil)
                }
            }

        }
        
    }
    

    fileprivate func delayExecutionByMilliseconds(_ delay: Int, for anonFunc: @escaping () -> Void) {
        let when = DispatchTime.now() + .milliseconds(delay)
        DispatchQueue.main.asyncAfter(deadline: when, execute: anonFunc)
    }
    

    @objc func goBack() {
        self.dismiss(animated: true, completion: nil)
        ViewController.count = 0
        
    }
    
    @objc func goNext() {
        self.dismiss(animated: true, completion: nil)
        if ViewController.count != 0{
            ViewController.isReverso = true
        }
    }
    
    func showData2(){
        var startIndex: String.Index
        var endIndex: String.Index
        var count = 0
        var countAux = 0
        
        var data = [String]()
        
        for item  in arrWords {
            data.append(item.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "]", with: "").replacingOccurrences(of: "[", with: ""))
            print(data)
        }
        
        data.indices.contains(0) ? apPaterno = data[0]      : (apPaterno    = "No reconocido")
        data.indices.contains(1) ? apMaterno = data[1]      : (apMaterno    = "No reconocido")
        data.indices.contains(2) ? name = data[2]           : (name         = "No reconocido")
        data.indices.contains(3) ? dir = data[3]            : (dir          = "No reconocido")
        data.indices.contains(4) ? dir.append(data[4])      : (dir          = "No reconocido")
        data.indices.contains(5) ? dir.append(data[5])      : (dir          = "No reconocido")
        data.indices.contains(6) ? folio.append(data[6])    : (folio        = "No reconocido")
        data.indices.contains(7) ? anioRegistro = data[7]   : (anioRegistro = "No reconocido")
        data.indices.contains(8) ? claveElector = data[8]   : (claveElector = "No reconocido")
        data.indices.contains(9) ? curp = data[9]           : (curp         = "No reconocido")
        data.indices.contains(10) ? estado = data[10]       : (estado       = "No reconocido")
        data.indices.contains(11) ? localidad = data[11]    : (localidad    = "No reconocido")
        data.indices.contains(12) ? emision  = data[12]     : (emision      = "No reconocido")
        data.indices.contains(13) ? municipio = data[13]    : (municipio    = "No reconocido")
        data.indices.contains(14) ? seccion = data[14]      : (seccion      = "No reconocido")
        data.indices.contains(15) ? vigencia = data[15]     : (vigencia     = "No reconocido")
        
        
        startIndex = folio.index(folio.endIndex, offsetBy: -13)
        folio = String(folio[startIndex..<folio.endIndex])
        
        startIndex = anioRegistro.index(anioRegistro.endIndex, offsetBy: -7)
        anioRegistro = String(anioRegistro[startIndex..<anioRegistro.endIndex])
        
        startIndex = claveElector.index(claveElector.endIndex, offsetBy: -13)
        claveElector = String(claveElector[startIndex..<claveElector.endIndex])
        
        startIndex = curp.index(curp.endIndex, offsetBy: -18)
        curp = String(curp[startIndex..<curp.endIndex])
        
        startIndex = municipio.index(municipio.endIndex, offsetBy: -3)
        municipio = String(municipio[startIndex..<municipio.endIndex])
        
        startIndex = vigencia.index(vigencia.endIndex, offsetBy: -4)
        vigencia = String(vigencia[startIndex..<vigencia.endIndex])
        

        print("----- Datos -----")
        print(apPaterno)
        print(apMaterno)
        print(name)
        print(dir)
        print(claveElector)
        print(curp)
        print(anioRegistro)
        print(estado)
        print(municipio)
        print(seccion)
        print(localidad)
        print(emision)
        print(vigencia)
        print("------------------")
        tfData.text = "Paterno: \(apPaterno) \nMaterno: \(apMaterno)\nNombre: \(name)\nDirección: \(dir)\nFolio: \(folio)\nClave Ele: \(claveElector)\nCurp: \(curp)\nAño Registro: \(anioRegistro)\nEdo: \(estado)\nMun: \(municipio)\nSec: \(seccion)\nLocalidad: \(localidad)\nEmisión: \(emision)\nVig: \(vigencia)"
    }
    

    func showData(){
        
        var startIndex: String.Index
        var endIndex: String.Index
        var count = 0
        var countAux = 0

        
        var data = [String]()
        
        for item  in arrWords {
            data.append(item.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "]", with: "").replacingOccurrences(of: "[", with: ""))
            print(data)
        }
        
        data.indices.contains(0) ? apPaterno = data[0]      : (apPaterno    = "No reconocido")
        data.indices.contains(1) ? apMaterno = data[1]      : (apMaterno    = "No reconocido")
        data.indices.contains(2) ? name = data[2]           : (name         = "No reconocido")
        data.indices.contains(3) ? dir = data[3]            : (dir          = "No reconocido")
        data.indices.contains(4) ? dir.append(data[4])      : (dir          = "No reconocido")
        data.indices.contains(5) ? dir.append(data[5])      : (dir          = "No reconocido")
        data.indices.contains(6) ? claveElector = data[6]   : (claveElector = "No reconocido")
        data.indices.contains(7) ? curp = data[7]           : (curp         = "No reconocido")
        data.indices.contains(9) ? estado = data[9]         : (estado       = "No reconocido")
        data.indices.contains(10) ? localidad = data[10]    : (localidad    = "No reconocido")
        data.indices.contains(11) ? municipio  = data[11]   : (municipio    = "No reconocido")
        data.indices.contains(12) ? emision = data[12]      : (emision      = "No reconocido")
        data.indices.contains(13) ? anioRegistro = data[13] : (anioRegistro = "No reconocido")
        data.indices.contains(14) ? seccion = data[14]      : (seccion      = "No reconocido")
        data.indices.contains(15) ? vigencia = data[15]     : (vigencia     = "No reconocido")

        print("----- Datos -----")
        print(apPaterno)
        print(apMaterno)
        print(name)
        print(dir)
        print(claveElector)
        print(curp)
        print(anioRegistro)
        print(estado)
        print(municipio)
        print(seccion)
        print(localidad)
        print(emision)
        print(vigencia)
        print("------------------")
        tfData.text = "Paterno: \(apPaterno) \nMaterno: \(apMaterno)\nNombre: \(name)\nDirección: \(dir)\nCE: \(claveElector)\nCurp: \(curp)\nAño Registro: \(anioRegistro)\nEdo: \(estado)\nMun: \(municipio)\nSec: \(seccion)\nLocalidad: \(localidad)\nEmisión: \(emision)\nVig: \(vigencia)"
    }

    //Vision Text Detection
    func startTextDetection(){
        let textRequest = VNDetectTextRectanglesRequest(completionHandler: self.detectTextHandler)
        textRequest.reportCharacterBoxes = true
        self.requests = [textRequest]
    }
    
    func detectTextHandler(request: VNRequest, error: Error?) {
        
        guard let observations = request.results else {
            print("no result")
            return
        }
        let result = observations.map({$0 as? VNTextObservation})
        
        DispatchQueue.main.async() {
            self.imageView.layer.sublayers?.removeSubrange(1...)
            for region in result {
                guard let rg = region else {
                    continue
                }
                let resultCGRect = self.highlightWord(box: rg)
                if let cgrect = resultCGRect{
                    let iImage = self.imageCropped.layer.asImage(rect: cgrect)                    
                    var isCorrect:Bool = false
                   
                    if let tesseract = G8Tesseract.init(language: "spa+Arial", engineMode: G8OCREngineMode.tesseractOnly){
                        var count: Int = 0
                        while(isCorrect != true){
                            //teseract
                            tesseract.image = iImage.g8_blackAndWhite()
                            tesseract.recognize()
                            tesseract.pageSegmentationMode = .autoOSD
                            //tesseract.charWhitelist = "ABCDEFGHIJKLMNÑOPQRSTUVWXYZÁÉÍÓÚ ,0123456789 -."
                            tesseract.charBlacklist = "|"
                            let reconized = tesseract.recognizedText.split(separator: "\n")
                            self.arrWords.append(String(describing: reconized))
                            G8Tesseract.clearCache()
                        
                            
                            if count == 0{
                                print("Data: \(self.arrWords[self.c]) -- \(self.c)")
                                
                                
                                for row in self.arrWords{
                                    print("\(row)\n")
                                }
                                isCorrect = true
                            }else{
                                print("---------------------")
                                print(tesseract.recognizedBlocks(by: G8PageIteratorLevel.textline))
                                count += 1
                                tesseract.image = nil
                            }
                            self.c += 1
                        }
                        self.tfData.text = tesseract.recognizedText

                        //getData(data: arrWords)
                    }
                    //self.indicator.stopAnimating()
                }
                self.imageView.image = self.imageView.image
            }
            //self.count += 1
            //self.analizeImage()
            
        }
    }
    
    func highlightWord(box: VNTextObservation) -> CGRect?{
        guard let boxes = box.characterBoxes else {
            return nil
        }
        var result: CGRect
        var maxX: CGFloat = 9999.0
        var minX: CGFloat = 0.0
        var maxY: CGFloat = 9999.0
        var minY: CGFloat = 0.0
        
        for char in boxes {
            if char.bottomLeft.x < maxX {
                maxX = char.bottomLeft.x
            }
            if char.bottomRight.x > minX {
                minX = char.bottomRight.x
            }
            if char.bottomRight.y < maxY {
                maxY = char.bottomRight.y
            }
            if char.topRight.y > minY {
                minY = char.topRight.y
            }
        }
        
        let xCord = maxX * imageView.frame.size.width
        let yCord = (1 - minY) * imageView.frame.size.height
        let width = (minX - maxX) * imageView.frame.size.width
        let height = (minY - maxY) * imageView.frame.size.height
        let outline = CALayer()
        result = CGRect(x: xCord-2, y: yCord-1, width: width+9, height: height+1)
        outline.frame = result
        outline.borderWidth = 2.0
        outline.borderColor = UIColor.red.cgColor
        print(result)
        imageView.layer.addSublayer(outline)
        return result
    }
    // Tesseract Image Recognition
    func performImageRecognition(_ image: UIImage) {
        self.imageView.image = image
        //Imagecrop
        imageCropped.image = image //UIImage(cgImage: (image.cgImage)!, scale: 1.0, orientation: UIImageOrientation.right)
        imageCropped.contentMode = .scaleToFill
        self.view.addSubview(imageCropped)
        imageOne = image
        let requestOptions:[VNImageOption : Any] = [:]
        let imageRequest = VNImageRequestHandler.init(cgImage: image.g8_blackAndWhite()!.cgImage!, options: requestOptions)
        do{
            try imageRequest.perform(self.requests)
        }catch let error{
            print(error.localizedDescription)
        }
        
    }
    
//    func analizeImage(){
//        startTextDetection()
//        switch self.count{
//        case 0:
//            self.performImageRecognition(self.cropImageFrontLeft(screenshot: (takenPhoto!.scaleImage(1080))!))
//        case 1:
//            self.performImageRecognition(self.cropImageFrontLeftName(screenshot: (takenPhoto!.scaleImage(1080))!))
//            break
//        case 2:
//           self.performImageRecognition(self.cropImageFrontLeftDir(screenshot: (takenPhoto!.scaleImage(1080))!))
//            break
//        case 3:
//           self.performImageRecognition(self.cropImageFrontLefOtherData(screenshot: (takenPhoto!.scaleImage(1080))!))
//            break
//        default:
//            break
//        }
//    }

    
    func cropImageFrontLeftName(screenshot: UIImage) -> UIImage {
        let crop = CGRect(x: 30, y: 220, width: 300 , height: 130)
        let cropImage = screenshot.cgImage?.cropping(to: crop)
        let image = UIImage(cgImage: cropImage!)
        return image
    }
    
    func cropImageFrontLeftDir(screenshot: UIImage) -> UIImage {
        let crop = CGRect(x: 20, y: 370, width: 570, height: 130)
        let cropImage = screenshot.cgImage?.cropping(to: crop)
        let image = UIImage(cgImage: cropImage!)
        return image
    }
    
    func cropImageFrontLeftFolRegEleCurp(screenshot: UIImage) -> UIImage {
        let crop = CGRect(x: 20, y: 470, width: 800 , height: 130)
        let cropImage = screenshot.cgImage?.cropping(to: crop)
        let image = UIImage(cgImage: cropImage!)
        return image
    }
    
    func cropImageFrontLeftOtherData(screenshot: UIImage) -> UIImage {
        let crop = CGRect(x: 120, y: 570, width: 130 , height: 130)
        let cropImage = screenshot.cgImage?.cropping(to: crop)
        let image = UIImage(cgImage: cropImage!)
        return image
    }
    
    func cropImageFrontLeftOtherData2(screenshot: UIImage) -> UIImage {
        let crop = CGRect(x: 300, y: 570, width: 220 , height: 130)
        let cropImage = screenshot.cgImage?.cropping(to: crop)
        let image = UIImage(cgImage: cropImage!)
        return image
    }
    
    
    // Right data
    
    func cropImageFrontRightName(screenshot: UIImage) -> UIImage{
        let crop = CGRect(x: 340, y: 230, width: 300, height: 125)
        let cropImage = screenshot.cgImage?.cropping(to: crop)
        let image = UIImage(cgImage: cropImage!)
        return image
    }
    
    func cropImageFrontRightDir(screenshot: UIImage) -> UIImage{
        let crop = CGRect(x: 340, y: 360, width: 600, height: 210)
        let cropImage = screenshot.cgImage?.cropping(to: crop)
        let image = UIImage(cgImage: cropImage!)
        return image
    }
    
    
    func cropImageFrontRightEdoLoc(screenshot: UIImage) -> UIImage{
        let crop = CGRect(x: 340, y: 560, width: 220, height: 250)
        let cropImage = screenshot.cgImage?.cropping(to: crop)
        let image = UIImage(cgImage: cropImage!)
        return image
    }
    
    func cropImageFrontRightMunEmi(screenshot: UIImage) -> UIImage{
        let crop = CGRect(x: 670, y: 560, width: 115, height: 200)
        let cropImage = screenshot.cgImage?.cropping(to: crop)
        let image = UIImage(cgImage: cropImage!)
        return image
    }
    
    func cropImageFrontRightRegSecVig(screenshot: UIImage) -> UIImage {
        let crop = CGRect(x: 880, y: 500, width: 280 , height: 250)
        let cropImage = screenshot.cgImage?.cropping(to: crop)
        let image = UIImage(cgImage: cropImage!)
        return image
    }
    
    
    func cropImageBack(screenshot: UIImage) -> UIImage{
        let crop = CGRect(x: 30, y: 400, width: 1000, height: 280)
        let cropImage = screenshot.cgImage?.cropping(to: crop)
        let image = UIImage(cgImage: cropImage!)
        return image
    }
    
    func analyze() {
        guard let facesCIImage = CIImage(image: imageView.image!)
            else { fatalError("can't create CIImage from UIImage") }
        let detectFaceRequest: VNDetectFaceRectanglesRequest = VNDetectFaceRectanglesRequest(completionHandler: self.handleFaces)
        let detectFaceRequestHandler = VNImageRequestHandler(ciImage: facesCIImage, options: [:])
        
        do {
            try detectFaceRequestHandler.perform([detectFaceRequest])
        } catch {
            print(error)
        }
    }
    
    func handleFaces(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNFaceObservation]
            else { fatalError("unexpected result type from VNDetectFaceRectanglesRequest") }
        
        self.addShapesToFace(forObservations: observations)
    }
    
    func addShapesToFace(forObservations observations: [VNFaceObservation]) {
        ViewController.countReverso = 0
        if let sublayers = imageView.layer.sublayers {
            for layer in sublayers {
                layer.removeFromSuperlayer()
            }
        }
        
        let imageRect = AVMakeRect(aspectRatio: imageView.frame.size, insideRect: imageView.bounds)
        
        let layers: [CAShapeLayer] = observations.map { observation in
            
            let w = observation.boundingBox.size.width * imageRect.width
            let h = observation.boundingBox.size.height * imageRect.height
            let x = observation.boundingBox.origin.x * imageRect.width
            let y = imageRect.maxY - (observation.boundingBox.origin.y * imageRect.height) - h

            print(x)
            print(w)
            if ViewController.isReverso == false{
                if x > 200 && w > 50 {
                    ViewController.count += 1
                }else if x < 100 && w > 50{
                    ViewController.count += 2
                }
                
            }else if ViewController.isReverso == true{
                ViewController.countReverso += 1
            }
           

            let layer = CAShapeLayer()
            layer.frame = CGRect(x: x , y: y, width: w, height: h)
            layer.borderColor = UIColor.red.cgColor
            layer.borderWidth = 2
            layer.cornerRadius = 3
            return layer
        }
        for layer in layers {
            imageView!.layer.addSublayer(layer)
        }
    }
}


// MARK: - UIImage extension
extension UIImage {
    func scaleImage(_ maxDimension: CGFloat) -> UIImage? {
        
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        if size.width > size.height {
            let scaleFactor = size.height / size.width
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            let scaleFactor = size.width / size.height
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        draw(in: CGRect(origin: .zero, size: scaledSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}
extension CALayer {
    func asImage(rect: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        return renderer.image { rendererContext in
            self.render(in: rendererContext.cgContext)
        }
    }
}
