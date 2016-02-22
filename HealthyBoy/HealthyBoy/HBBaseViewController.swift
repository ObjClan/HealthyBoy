//
//  HBBaseViewController.swift
//  HealthyBoy
//
//  Created by jszx on 16/2/17.
//  Copyright © 2016年 jszx. All rights reserved.
//


class HBBaseViewController: UIViewController,UITextFieldDelegate {
    let navView = UIView()
    let backBtn = UIButton()
    var navTitle = String()
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.init(hexString: "#F6F5F6")
        navView.backgroundColor = UIColor.init(hexString: "#F6F6F6")
        self.view.addSubview(navView)
        navView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.height.equalTo(HBCommon.getCellHeight() * 2)
        }
        backBtn.setTitle("back", forState: UIControlState.Normal)
        backBtn.setTitleColor(UIColor.init(hexString: "#808080"), forState: UIControlState.Normal)
        backBtn.addTarget(self, action: "backBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        navView.addSubview(backBtn)
        backBtn.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(navView)
            make.left.equalTo(navView).offset(10)
            make.width.equalTo(50)
            make.height.equalTo(navView)
        }
        let titleLabel = UILabel()
        titleLabel.text = navTitle
        titleLabel.textColor = UIColor.init(hexString: "#808080")
        titleLabel.textAlignment = NSTextAlignment.Center
        navView.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(navView)
            make.centerX.equalTo(navView)
            make.width.equalTo(100)
            make.height.equalTo(navView)
        }
        
    }
    
    func boundingTextRect(text : NSString,font : UIFont,size: CGSize)->CGRect{
     
       return text.boundingRectWithSize(size, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: NSDictionary(objects: [font], forKeys: [NSFontAttributeName]) as? [String : AnyObject], context: nil)
    }
    
    func backBtnClick() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}



