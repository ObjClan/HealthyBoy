//
//  HBCenterController.swift
//  HealthyBoy
//
//  Created by jszx on 16/2/17.
//  Copyright © 2016年 jszx. All rights reserved.
//

class HBCenterController {
    let hostName = "10.8.3.222"
    let domain = "object.local"
  
//    internal let hostName = "10.0.0.107"
//    internal let domain = "object"
    var username: String?
    
    private var timer = NSTimer()
    private var pwd: String?
    //单例
    private static let _sharedInstance = HBCenterController()
    class func sharedInstance() ->HBCenterController {
        return _sharedInstance
    }
    
    private init(){
    
    }
    
    
}

