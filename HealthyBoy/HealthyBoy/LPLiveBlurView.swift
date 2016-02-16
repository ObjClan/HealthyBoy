////
////  LPLiveBlurView.swift
////  HealthyBoy
////
////  Created by jszx on 16/2/15.
////  Copyright © 2016年 jszx. All rights reserved.
////
//
//import Foundation
//import UIKit
//import Accelerate
//
//class LPLiveBlurView: UIView {
//    
//    var originalImage = UIImageView()
//    var initialBlurLevel = 0.0
//    var initialGlassLevel = 0.0
//    var isGlassEffectOn = false
//    
//    //setter,getter
//    var _glassColor: UIColor?
//    var glassColor: UIColor{
//        set {
//            _glassColor = newValue
//            backgroundGlassView.backgroundColor = _glassColor
//        }
//        get {
//            return _glassColor!
//        }
//    }
//    
//    private var backgroundImageView = UIImageView()
//    private var backgroundGlassView = UIView()
//    
//    override internal init(frame: CGRect) {
//        super.init(frame: frame)
//        initialBlurLevel = 0.9
//        initialGlassLevel = 0.2
//        glassColor = UIColor.whiteColor()
//        backgroundImageView = UIImageView.init(frame: self.bounds)
//        backgroundImageView.alpha = 0.0
//        backgroundImageView.contentMode = UIViewContentMode.ScaleToFill
//        backgroundImageView.backgroundColor = UIColor.clearColor()
//        backgroundImageView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
//        self.addSubview(backgroundImageView)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func applyBlurOnImage(imageToBlur: UIImage,var blurRadius: CGFloat)->UIImage {
//        if blurRadius <= 0.0 || blurRadius > 1.0 {
//            blurRadius = 0.5
//        }
//        
//        var boxSize = Int(Float(blurRadius) * 100)
//        boxSize -= (boxSize % 2) + 1
//        var rawImage = imageToBlur.CGImage
//        var inBuffer: vImage_Buffer?
//        var outBuffer: vImage_Buffer?
//        var error: vImage_Error?
//        var pixelBuffer: Void?
//        var inProvider = CGImageGetDataProvider(rawImage)
//        var inBitmapData = CGDataProviderCopyData(inProvider)
//        inBuffer?.width = vImagePixelCount(CGImageGetWidth(rawImage))
//        inBuffer?.height = vImagePixelCount(CGImageGetHeight(rawImage))
//        inBuffer?.rowBytes = CGImageGetBytesPerRow(rawImage)
////        inBuffer?.data = CFDataGetBytePtr(inBitmapData)
////        pixelBuffer = malloc(CGImageGetBytesPerRow(rawImage) * CGImageGetHeight(rawImage))
////        outBuffer?.data = pixelBuffer
//        
//    }
//    
//    func setBlurLevel(blurLevel : Float) {
//    
//    }
//    
//    
//
//}