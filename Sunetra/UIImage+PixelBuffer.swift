//
//  UIImage+PixelBuffer.swift
//  MLInt
//
//  Created by Anmol Ranjan on 03/06/24.
//

import UIKit

extension UIImage {
    // Function to convert UIImage to CVPixelBuffer
    func pixelBuffer(width: Int, height: Int) -> CVPixelBuffer? {
        // Begin image context
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), true, 2.0)
        defer { UIGraphicsEndImageContext() } // End image context when function exits
        draw(in: CGRect(x: 0, y: 0, width: width, height: height)) // Draw image in context
        guard let context = UIGraphicsGetCurrentContext() else { return nil } // Get current context
        
        // Create CGImage from context
        guard let cgImage = context.makeImage() else { return nil } // Convert context to CGImage
        
        var pixelBuffer: CVPixelBuffer? // Initialize pixel buffer
        
        // Define options for pixel buffer creation
        let options: [String: Any] = [
            kCVPixelBufferCGImageCompatibilityKey as String: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey as String: true
        ]
        
        // Create pixel buffer
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32ARGB, options as CFDictionary, &pixelBuffer)
        // Check if pixel buffer creation was successful
        guard status == kCVReturnSuccess, let unwrappedPixelBuffer = pixelBuffer else { return nil }
        CVPixelBufferLockBaseAddress(unwrappedPixelBuffer, [])
        let data = CVPixelBufferGetBaseAddress(unwrappedPixelBuffer) // Get base address of pixel buffer
        
        // Create RGB color space
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        // Define bitmap info
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        // Create context for pixel buffer
        let context2 = CGContext(data: data, width: width, height: height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(unwrappedPixelBuffer), space: rgbColorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        // Draw CGImage in pixel buffer context
        context2?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        CVPixelBufferUnlockBaseAddress(unwrappedPixelBuffer, [])

        return unwrappedPixelBuffer
    }
}
