//
//  HBAuthViewController.swift
//  HealthyBoy
//
//  Created by jszx on 16/2/16.
//  Copyright © 2016年 jszx. All rights reserved.
//

class HBAuthViewController: HBBaseViewController{
    @IBOutlet weak var accountTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    override func viewDidLoad() {
        accountTF.text = "xiexiang@object.local"
        pwdTF.text = "123456"
        
        accountTF.delegate = self
        pwdTF.delegate = self
        
        navTitle = "登录"
        super.viewDidLoad()
        pwdTF.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(view)
            make.width.equalTo(HBCommon.getCellWidth())
            make.height.equalTo(HBCommon.getCellHeight())
        }
        accountTF.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(pwdTF)
            make.width.height.equalTo(pwdTF)
            make.bottom.equalTo(pwdTF.snp_top).offset(-HBCommon.getCellMarge())
        }
        submitBtn.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(pwdTF)
            make.width.height.equalTo(pwdTF)
            make.top.equalTo(pwdTF.snp_bottom).offset(HBCommon.getCellMarge())
        }
    }
    @IBAction func submitBtnClick(sender: UIButton) {
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.connect(accountTF.text!, password: pwdTF.text!)
        
        HBCenterController.sharedInstance().username = accountTF.text
        self.performSegueWithIdentifier("loginAuthSegue", sender: self)
    }
    
    
    deinit {
        NSLog("HBAuthViewController deinit")
    }
    
}
