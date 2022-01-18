//
//  SpriteKit+Extension.swift
//  EarthquakeFinder
//
//  Created by Jordan Trana on 8/19/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//

import SpriteKit

extension CGImage {
    
    
    // MARK: CGRect
    
    var rect:CGRect {
        return CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height))
    }
    
    // MARK: Rotate
    
    func imageRotatedByDegrees(degrees: CGFloat) -> CGImage {
        //Create the bitmap context
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        let context: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        context.translateBy(x: CGFloat(width) / 2, y: CGFloat(height) / 2)
        //Rotate the image context
        context.rotate(by: ((degrees - 90) * CGFloat.pi / 180))
        //Now, draw the rotated/scaled image into the context
        context.scaleBy(x: 1.0, y: -1.0)
        context.draw(self, in: CGRect(x: -width / 2, y: -height / 2, width: width, height: height))
        
        UIGraphicsEndImageContext()
        return context.makeImage()!
    }
    
    // MARK: Grayscale
    
    func convertToGrayScale() -> CGImage {
        let imageRect:CGRect = CGRect(x:0, y:0, width:width, height: height)
        let colorSpace = CGColorSpaceCreateDeviceGray()

        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        //have to draw before create image

        context?.draw(self, in: imageRect)

        return context!.makeImage()!
    }
    
    // MARK: Merge Image
    
    func mergeMask(with otherMask:CGImage) -> CGImage {
        return self.merge(with: otherMask, colorSpace: CGColorSpaceCreateDeviceGray(), blendMode: .screen)
    }

    func merge(with otherImage:CGImage, colorSpace:CGColorSpace? = nil, blendMode:CGBlendMode = .screen) -> CGImage {
        return merge(with: [otherImage], colorSpace: colorSpace)
    }
    
    func merge(with otherImages:[CGImage], colorSpace:CGColorSpace? = nil, blendMode:CGBlendMode = .screen) -> CGImage {
        
        let colorSpace = colorSpace ?? self.colorSpace!
        
        // Setup Drawing
        let imageRect:CGRect = CGRect(x:0, y:0, width:width, height: height)
        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        context?.setBlendMode(blendMode)
        
        context?.draw(self, in: imageRect)
        
        //have to draw before create image
        for otherImage in otherImages {
            context?.draw(otherImage, in: imageRect)
        }
        
        return context!.makeImage()!
    }
    
    // MARK: Blank Image
    
    static func blankMask(size:CGSize) -> CGImage {
        return blankMask(width: Int(size.width), height: Int(size.height))
    }
    
    static func blankMask(width:Int, height:Int) -> CGImage {
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width*4, space: CGColorSpaceCreateDeviceGray() , bitmapInfo: bitmapInfo.rawValue)
        return context!.makeImage()!
    }
    
    static func blank(width:Int, height:Int) -> CGImage {
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width*4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: bitmapInfo.rawValue)
        return context!.makeImage()!
    }
}
