//
//  LPRootViewController.swift
//  HealthyBoy
//
//  Created by jszx on 16/2/15.
//  Copyright © 2016年 jszx. All rights reserved.
//


class HBLoginViewController: HBBaseViewController {
    
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    var _backColor: UIColor?
    var backColor: UIColor? {
        set {
            _backColor = newValue
        }
        get {
            return _backColor!
        }
    }
    
    var backgroundView: DKLiveBlurView?
    
    override func viewDidLoad() {
        
        self.backColor = UIColor.redColor()
        self.view.backgroundColor = self.backColor
        
        backgroundView = DKLiveBlurView(frame: self.view.bounds)
        backgroundView!.isGlassEffectOn = true
        backgroundView!.originalImage = UIImage(named: "1.png")
        backgroundView?.glassColor = UIColor.grayColor()
        self.view.addSubview(backgroundView!)
        self.view.sendSubviewToBack(backgroundView!)
        
        let delayInSeconds = 0.1
        let popTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(delayInSeconds * Double(NSEC_PER_SEC)))
        
        weak var weakSelf = self
        dispatch_after(popTime, dispatch_get_main_queue(), {
            weakSelf!.backgroundView?.setBlurLevel(0.9)
        })
        
        let width = HBCommon.getCellWidth()
        let height = HBCommon.getCellHeight()
        
        loginBtn.snp_remakeConstraints { (make) -> Void in
            make.width.equalTo(width)
            make.height.equalTo(height)
            make.centerX.equalTo(self.view.snp_centerX)
            make.bottom.equalTo(self.view).offset(-50)
        }
        
        registerBtn.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(loginBtn)
            make.height.equalTo(loginBtn)
            make.centerX.equalTo(loginBtn)
            make.bottom.equalTo(loginBtn.snp_top).offset(-HBCommon.getCellMarge())
        }
    }
    
    
    
    deinit {
        
    }
   


}