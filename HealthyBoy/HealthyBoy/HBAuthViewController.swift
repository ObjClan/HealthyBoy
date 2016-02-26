//
//  HBAuthViewController.swift
//  HealthyBoy
//
//  Created by jszx on 16/2/16.
//  Copyright © 2016年 jszx. All rights reserved.
//

class HBAuthViewController: HBBaseViewController,HBLoginResultDelegate,UIAlertViewDelegate{
    @IBOutlet weak var accountTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    private var timer : NSTimer?
    private var isOpenCheckLogin = false
    private var isReConnect = false
    private let queue = dispatch_queue_create("checkLoginQueue", nil)
    
    override func viewDidLoad() {
//        accountTF.text = "xiexiang@object"
//        pwdTF.text = "123456"
        
        accountTF.delegate = self
        pwdTF.delegate = self
        
        navTitle = "登录"
        super.viewDidLoad()
        
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.loginResultDelegate = self
        
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
        let myUsername = accountTF.text! + "@" + HBCenterController.sharedInstance().domain
        appdelegate.connect(myUsername, password: pwdTF.text!)
        
        HBCenterController.sharedInstance().username = myUsername
        
    }
    
    func loginResult(status: Int, message: String) {
        if status == 0 {
            
            if isOpenCheckLogin == false {
                
                dispatch_async(queue, { () -> Void in
                    self.openCheckLoginStatusLoop()
                })
            }
            
            if isReConnect == false {
                self.performSegueWithIdentifier("loginAuthSegue", sender: self)
            }
            
            
        } else {
            NSLog(message)
        }
    }
    
    //
    func openCheckLoginStatusLoop() {
        
        isOpenCheckLogin = true
        
        timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector:Selector("checkLoginStatus") , userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().run()
        timer!.fire()
    }
    
    func checkLoginStatus() {
        
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if appdelegate.isOnLine() == false {
            
            timer?.invalidate()
            
            let alert = UIAlertView.init(title: "提示", message: "您已断开连接", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "重连")
            alert.tag = 1000
            alert.show()

        } else {
//            NSLog("\(NSThread.currentThread())" + "," +  "\(NSThread.currentThread().name)")
//            NSLog("连接成功")
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView.tag == 1000 {
            if buttonIndex == 1 {
                isOpenCheckLogin = false
                isReConnect = true
                let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appdelegate.connect(accountTF.text! + "@" + HBCenterController.sharedInstance().domain, password: pwdTF.text)
            } else if buttonIndex == 0 {
                isReConnect = false
                isOpenCheckLogin = false
                self.navigationController?.popToViewController(self, animated: true)
            }
        }
        
    }
    deinit {
        NSLog("HBAuthViewController deinit")
    }
    
}
