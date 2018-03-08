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
    
    func GARFilter() -> UIImage?{
        guard let filter = CIFilter(name: "CIPhotoEffectNoir"), let ciImage = CIImage.init(image: self) else{
            return nil
        }
        let context = CIContext()
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        if let imageOutPut = filter.outputImage?.applyingFilter("CIColorControls", parameters: [kCIInputContrastKey: 3, kCIInputBrightnessKey: 0.98, kCIInputSaturationKey: 0]), let image = context.createCGImage(imageOutPut, from: imageOutPut.extent){
            
            let result = UIImage.init(cgImage: image, scale: 1.0, orientation: .up)
            return result
            
        }
        return nil
    }
    
}
