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
    internal class func getScreenWidth() -> CGFloat {
        return UIScreen.mainScreen().bounds.width
    }
    
    internal class func getScreenHeight() -> CGFloat {
        return UIScreen.mainScreen().bounds.height
    }
    
    internal class func getCellWidth() -> CGFloat {
        return UIScreen.mainScreen().bounds.width * 0.8
    }
    
    internal class func getCellHeight() -> CGFloat {
        return UIScreen.mainScreen().bounds.height * 0.06
    }
    
    internal class func getCellMarge() -> CGFloat {
        return HBCommon.getCellHeight() * 0.3
    }
}