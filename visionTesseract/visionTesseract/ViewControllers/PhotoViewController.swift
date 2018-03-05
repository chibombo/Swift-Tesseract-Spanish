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
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tfData: UITextView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let availableImage = takenPhoto?.scaleImage(1080) {
            
            imageView.image = availableImage
            imageView.contentMode = .scaleAspectFit
            
            startTextDetection()
            self.performImageRecognition(self.cropImageFrontLeftName(screenshot: (imageView.image?.g8_blackAndWhite())!))

            self.performImageRecognition(self.cropImageFrontLeftDir(screenshot: (imageView.image?.g8_blackAndWhite())!))
            
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
                
                self.highlightWord(box: rg)
            }
        }
    }
    
    func highlightWord(box: VNTextObservation) {
        guard let boxes = box.characterBoxes else {
            return
        }
        
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
        outline.frame = CGRect(x: xCord, y: yCord, width: width, height: height)
        outline.borderWidth = 2.0
        outline.borderColor = UIColor.red.cgColor
        print(outline.frame)
        imageView.layer.addSublayer(outline)
    }
    // Tesseract Image Recognition
    func performImageRecognition(_ image: UIImage) {
       
        
        let requestOptions:[VNImageOption : Any] = [:]
        let imageRequest = VNImageRequestHandler.init(cgImage: image.cgImage!, options: requestOptions)
        do{
            try imageRequest.perform(self.requests)
        }catch let error{
            print(error.localizedDescription)
        }
        var isCorrect:Bool = false
        var arrWords = [String]()
        if let tesseract = G8Tesseract.init(language: "spa+Arial", engineMode: G8OCREngineMode.tesseractOnly){
            var count: Int = 0
            while(isCorrect != true){
                
                //teseract
                
                tesseract.pageSegmentationMode = .auto
                //tesseract.image = image.g8_blackAndWhite()
                //tesseract.charWhitelist = "ABCDEFGHIJKLMNÑOPQRSTUVWXY Z ,0123456789 -."
                tesseract.analyseLayout()
                tesseract.recognize()
                
                
                
                //        let img = UIImageView.init(frame: CGRect(x: 100, y: 300, width: 200, height: 170))
                //
                //        img.image = tesseract.image(withBlocks: tesseract.recognizedBlocks(by: G8PageIteratorLevel.word), drawText: true, thresholded: true)
                //
                //        img.contentMode = UIViewContentMode.scaleAspectFill
                //        self.view.addSubview(img)
                
                //Imagecrop
                let imageCropped = UIImageView.init(frame: CGRect(x: 100, y: 450, width: 200, height: 170))
//                let cropImage = self.cropImageFrontLeftName(screenshot: image.g8_blackAndWhite())
                imageCropped.image = image //UIImage(cgImage: (image.cgImage)!, scale: 1.0, orientation: UIImageOrientation.right)
                
                imageCropped.contentMode = UIViewContentMode.scaleAspectFill
                self.view.addSubview(imageCropped)
                
                tesseract.image = imageCropped.image?.g8_blackAndWhite()!
                
                
                arrWords.append(String(describing: tesseract.recognizedText.split(separator: "\n")))
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
            tfData.text = tesseract.recognizedText
            //getData(data: arrWords)
        }
        indicator.stopAnimating()
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
