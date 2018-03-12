//
//  ImageEditor.swift
//  visionTesseract
//
//  Created by Luis Genaro Arvizu Vega on 06/03/18.
//  Copyright © 2018 Genaro. All rights reserved.
//

import UIKit
import CoreImage

extension UIImage{
    
    var jpeg: Data?{
        return UIImageJPEGRepresentation(self, 1.0)
    }
    
    var png: Data?{
        return UIImagePNGRepresentation(self)
    }
    
    var brightness: Double?{
        let context = CIContext()
        guard let image = CIImage(image: self) else {return nil}
        guard let cgImage = context.createCGImage(image, from: image.extent) else {return nil}
        let width = cgImage.width
        let height = cgImage.height
        let pixels = CFDataGetLength(cgImage.dataProvider!.data!)
        let pixel =  CFDataGetBytePtr(cgImage.dataProvider!.data!)
        var brightness: Double = 0
        for count in stride(from: 0, to: pixels, by: 4){
            let r = pixel![count]
            let g = pixel![count+1]
            let b = pixel![count+2]
            brightness += (Double(r)*0.299 + Double(g)*0.587 + Double(b)*0.114)
        }
        brightness /= Double(width * height)
        brightness /= 255
        return brightness
    }
    
    func GARFilter() -> UIImage?{
        guard let filter = CIFilter(name: "CIPhotoEffectNoir"), let ciImage = CIImage.init(image: self) else{
            return nil
        }
        let context = CIContext()
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        if let imageOutPut = filter.outputImage?.applyingFilter("CIColorControls", parameters: [kCIInputContrastKey: 3, kCIInputBrightnessKey: 0.80, kCIInputSaturationKey: 0]), let image = context.createCGImage(imageOutPut, from: imageOutPut.extent){
            
            let result = UIImage.init(cgImage: image, scale: 1.0, orientation: .up)
            return result
            
        }
        return nil
    }
    
}
