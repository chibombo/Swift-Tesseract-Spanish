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

class PhotoViewController: UIViewController {
    
    var takenPhoto:UIImage?
    var requests: [VNRequest] = [VNRequest]()
    var imageCropped: UIImageView!
    var imageOne: UIImage!
    var count: Int8 = 1
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tfData: UITextView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        imageCropped = UIImageView.init(frame: CGRect(x: 10, y: 450, width:imageView.frame.width, height: imageView.frame.height))
        if let availableImage = takenPhoto?.scaleImage(1080) {
            
            imageView.image = availableImage
            imageView.contentMode = .scaleToFill
            
            
            self.analizeImage()
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
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
                    var arrWords = [String]()
                    if let tesseract = G8Tesseract.init(language: "spa", engineMode: G8OCREngineMode.tesseractOnly){
                        var count: Int = 0
                        while(isCorrect != true){
                            //teseract
                            tesseract.image = iImage.g8_blackAndWhite()
                            tesseract.recognize()
                            tesseract.pageSegmentationMode = .autoOSD
                            tesseract.charWhitelist = "ABCDEFGHIJKLMNÑOPQRSTUVWXYZÁÉÍÓÚ ,0123456789 -."
                            
                            let reconized = tesseract.recognizedText.split(separator: "\n")
                            arrWords.append(String(describing: reconized))
                            G8Tesseract.clearCache()
                            
                            if count == 0{
                                for row in arrWords{
                                    print("\(row)\n")
                                }
                                isCorrect = true
                            }else{
                                print("---------------------")
                                print(tesseract.recognizedBlocks(by: G8PageIteratorLevel.textline))
                                count += 1
                                tesseract.image = nil
                            }
                        }
                        self.tfData.text = tesseract.recognizedText
                        //getData(data: arrWords)
                    }
                    self.indicator.stopAnimating()
                }
            }
            self.count += 1
            self.analizeImage()
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
        result = CGRect(x: xCord-2, y: yCord-1, width: width+9, height: height+2)
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
        let imageRequest = VNImageRequestHandler.init(cgImage: image.cgImage!, options: requestOptions)
        do{
            try imageRequest.perform(self.requests)
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    func analizeImage(){
        startTextDetection()
        switch self.count{
        case 0:
            self.performImageRecognition(self.cropImageFrontLeft(screenshot: (takenPhoto!.scaleImage(1080))!))
        case 1:
            self.performImageRecognition(self.cropImageFrontLeftName(screenshot: (takenPhoto!.scaleImage(1080))!))
            break
        case 2:
           self.performImageRecognition(self.cropImageFrontLeftDir(screenshot: (takenPhoto!.scaleImage(1080))!))
            break
        case 3:
           self.performImageRecognition(self.cropImageFrontLefOtherData(screenshot: (takenPhoto!.scaleImage(1080))!))
            break
        default:
            break
        }
    }
    
    
    func cropImageFrontLeft(screenshot: UIImage) -> UIImage {
        let crop = CGRect(x: 30, y: 195, width: 680 , height: 680)
        let cropImage = screenshot.cgImage?.cropping(to: crop)
        let image = UIImage(cgImage: cropImage!)
        return image
    }
    
    func cropImageFrontLeftName(screenshot: UIImage) -> UIImage {
        let crop = CGRect(x: 30, y: 200, width: 300 , height: 150)
        let cropImage = screenshot.cgImage?.cropping(to: crop)
        let image = UIImage(cgImage: cropImage!)
        return image
    }
    
    func cropImageFrontLeftDir(screenshot: UIImage) -> UIImage {
        let crop = CGRect(x: 20, y: 370, width: 570 , height: 130)
        let cropImage = screenshot.cgImage?.cropping(to: crop)
        let image = UIImage(cgImage: cropImage!)
        return image
    }
    
    //  func cropImageFrontLeftDir(screenshot: UIImage) -> UIImage {
    //    let crop = CGRect(x: 30, y: 500, width: 600 , height: 30)
    //    let cropImage = screenshot.cgImage?.cropping(to: crop)
    //    let image = UIImage(cgImage: cropImage!)
    //    return image
    //  }
    
    func cropImageFrontLefOtherData(screenshot: UIImage) -> UIImage {
        let crop = CGRect(x: 30, y: 560, width: 600 , height: 150)
        let cropImage = screenshot.cgImage?.cropping(to: crop)
        let image = UIImage(cgImage: cropImage!)
        return image
    }
    
    // Right data
    
    func cropImageFrontRight(screenshot: UIImage) -> UIImage{
        let crop = CGRect(x: 340, y: 165, width: 750, height: 450)
        let cropImage = screenshot.cgImage?.cropping(to: crop)
        let image = UIImage(cgImage: cropImage!)
        return image
    }
    
    func cropImageFrontRightName(screenshot: UIImage) -> UIImage{
        let crop = CGRect(x: 340, y: 165, width: 350, height: 130)
        let cropImage = screenshot.cgImage?.cropping(to: crop)
        let image = UIImage(cgImage: cropImage!)
        return image
    }
    //  func cropImageFrontRightDir(screenshot: UIImage) -> UIImage{
    //    let crop = CGRect(x: 340, y: 180, width: 500, height: 300)
    //    let cropImage = screenshot.cgImage?.cropping(to: crop)
    //    let image = UIImage(cgImage: cropImage!)
    //    return image
    //  }
    
    func cropImageFrontRightDir(screenshot: UIImage) -> UIImage{
        let crop = CGRect(x: 340, y: 310, width: 750, height: 140)
        let cropImage = screenshot.cgImage?.cropping(to: crop)
        let image = UIImage(cgImage: cropImage!)
        return image
    }
    func cropImageFrontRightOtherData(screenshot: UIImage) -> UIImage{
        let crop = CGRect(x: 340, y: 165, width: 750, height: 450)
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
}


// MARK: - UIImagePickerControllerDelegate
extension PhotoViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage, let scaledImage = image.scaleImage(1080){
            print("entro a 1")
            indicator.startAnimating()
            
            dismiss(animated: true, completion: {
                self.performImageRecognition(scaledImage)
            })
        }else if let selectedPhoto = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let scaledImage = selectedPhoto.scaleImage(1080) {
            print("entro a 2")
            indicator.startAnimating()
            
            dismiss(animated: true, completion: {
                self.performImageRecognition(scaledImage)
            })
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
