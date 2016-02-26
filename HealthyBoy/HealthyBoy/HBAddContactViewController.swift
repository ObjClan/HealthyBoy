//
//  HBAddContactViewController.swift
//  HealthyBoy
//
//  Created by jszx on 16/2/23.
//  Copyright © 2016年 jszx. All rights reserved.
//


class HBAddContactViewController: HBBaseViewController {
    
    @IBOutlet weak var contactName: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    
    override func viewDidLoad() {
        
        self.navTitle = "添加联系人"
        self.contactName.delegate = self
        
        super.viewDidLoad()
        
        addBtn!.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self.view)
            make.width.equalTo(HBCommon.getCellWidth())
            make.height.equalTo(HBCommon.getCellHeight())
        }
        contactName!.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(addBtn!)
            make.width.height.equalTo(addBtn!)
            make.bottom.equalTo(addBtn!.snp_top).offset(-HBCommon.getCellMarge())
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name:UIKeyboardWillShowNotification , object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name:UIKeyboardWillHideNotification , object: nil)
    }
    
    @IBAction func addBtnClick(sender: UIButton) {
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.addFriendSubscribe(contactName.text!)
    }
    
    //键盘遮挡输入框处理、autoLayout动画
    
    func keyboardWillShow(info: NSNotification){

//        let keyboardBounds = info.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue
//        
//        UIView.animateWithDuration(0.5) { () -> Void in
//            self.view.layoutIfNeeded()
//        }
        
    }
    
    func keyboardWillHide(info: NSNotification){
//        UIView.animateWithDuration(0.5) { () -> Void in
//            self.view.layoutIfNeeded()
//        }
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}
