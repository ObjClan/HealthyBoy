//
//  HBCommon.swift
//  HealthyBoy
//
//  Created by jszx on 16/2/16.
//  Copyright © 2016年 jszx. All rights reserved.
//

import Foundation
import UIKit

class HBCommon {
    class func getScreenWidth() -> CGFloat {
        return UIScreen.mainScreen().bounds.width
    }
    
    class func getScreenHeight() -> CGFloat {
        return UIScreen.mainScreen().bounds.height
    }
    
    class func getCellWidth() -> CGFloat {
        return UIScreen.mainScreen().bounds.width * 0.8
    }
    
    class func getCellHeight() -> CGFloat {
        return UIScreen.mainScreen().bounds.height * 0.06
    }
    
    class func getCellMarge() -> CGFloat {
        return HBCommon.getCellHeight() * 0.3
    }
}