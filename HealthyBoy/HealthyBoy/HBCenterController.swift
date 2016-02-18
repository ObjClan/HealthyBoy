//
//  HBCenterController.swift
//  HealthyBoy
//
//  Created by jszx on 16/2/17.
//  Copyright © 2016年 jszx. All rights reserved.
//

class HBCenterController {
    internal let hostName = "localhost"
    internal let domain = "object.local"

    //单例
    private static let _sharedInstance = HBCenterController()
    class func sharedInstance() ->HBCenterController {
        return _sharedInstance
    }
    
    private init(){
    
    }
}

