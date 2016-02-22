//
//  HBChatViewController.swift
//  HealthyBoy
//
//  Created by jszx on 16/2/19.
//  Copyright © 2016年 jszx. All rights reserved.
//

class HBChatViewController: HBBaseViewController,UITableViewDataSource,UITableViewDelegate {
    var unreadList = [HBMessage]()               //所有未读消息
    var currentFriendUnreadList = [HBMessage]()  //当前好友未读消息
    var name : String?                           //当前正在聊天的好友
    let tableView = UITableView()
    private let inputTF = UITextField()
    private let inputMessageView = UIView()
    
    override func viewDidLoad() {
        self.navTitle = name!
        super.viewDidLoad()
        
        for msg in unreadList {
            if msg.from == name {
                currentFriendUnreadList.append(msg)
            }
        }
        
        inputMessageView.backgroundColor = UIColor.grayColor()
        self.view.addSubview(inputMessageView)
        inputMessageView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
            make.height.equalTo(60)
        }
        
        inputTF.delegate = self
        inputMessageView.addSubview(inputTF)
        inputTF.backgroundColor = UIColor.whiteColor()
        
        let sendBtn = UIButton()
        inputMessageView.addSubview(sendBtn)
        sendBtn.setTitle("发送", forState: UIControlState.Normal)
        sendBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        sendBtn.addTarget(self, action: "senBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        inputTF.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(inputMessageView)
            make.left.equalTo(inputMessageView.snp_left).offset(20)
            make.height.equalTo(HBCommon.getCellHeight())
            make.right.equalTo(sendBtn.snp_left).offset(-10)
        }
        
        
        sendBtn.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(inputTF)
            make.height.equalTo(inputTF)
            make.width.equalTo(40)
            make.right.equalTo(view.snp_right).offset(-20)
        }
        
        self.view.addSubview(tableView)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.navView.snp_bottom)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(inputMessageView.snp_top)
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        if currentFriendUnreadList.count > 0 {
            tableView.scrollToRowAtIndexPath(NSIndexPath.init(forRow: currentFriendUnreadList.count - 1, inSection: 0), atScrollPosition:UITableViewScrollPosition.Bottom,animated:true)
        }
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name:UIKeyboardWillShowNotification , object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name:UIKeyboardWillHideNotification , object: nil)
    }

    func senBtnClick() {
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.sendMessage(inputTF.text!, fromUser: HBCenterController.sharedInstance().username!, toUser: name!)
        inputTF.text = ""
        inputTF.resignFirstResponder()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentFriendUnreadList.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let id = "chatCellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(id)
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: id)
            cell?.selected = false
            
            let iconImageView = UIImageView()
            iconImageView.tag = 3
            cell?.contentView.addSubview(iconImageView)
            
            let messageLabel = UILabel()
            messageLabel.tag = 1
            messageLabel.numberOfLines = 0
            //有符号时计算rect需要设置
            messageLabel.lineBreakMode = NSLineBreakMode.ByCharWrapping
            //label最大宽度
            messageLabel.preferredMaxLayoutWidth = (cell?.contentView.frame.size.width)! * 0.7
            cell?.contentView.addSubview(messageLabel)
            
            let messageBackgroundView = UIImageView()
            messageBackgroundView.tag = 2
            cell?.contentView.addSubview(messageBackgroundView)
            cell?.contentView.sendSubviewToBack(messageBackgroundView)
            
        }
        
        let messagelabel = cell?.contentView.viewWithTag(1) as! UILabel
        messagelabel.backgroundColor = UIColor.clearColor()
        NSLog(currentFriendUnreadList[indexPath.row].body)
        messagelabel.text = currentFriendUnreadList[indexPath.row].body
        
        let rect = boundingTextRect(messagelabel.text!, font: messagelabel.font, size: CGSizeMake((cell?.contentView.frame.size.width)! * 0.7, 0))
        
        let iconView = cell?.contentView.viewWithTag(3) as! UIImageView
        iconView.image = UIImage(named: "xiaohua")
        iconView.snp_remakeConstraints { (make) -> Void in
            make.left.equalTo((cell?.contentView)!).offset(10)
            make.bottom.equalTo(messagelabel).offset(20)
        }
        
        
        messagelabel.snp_remakeConstraints { (make) -> Void in
            make.top.equalTo((cell?.contentView)!).offset(10)
            make.left.equalTo(iconView.snp_right).offset(20)
            make.height.equalTo(rect.height)
        }
        
        let msgBackgroundView = cell?.contentView.viewWithTag(2) as! UIImageView
        msgBackgroundView.image = UIImage(named: "yoububble")?.stretchableImageWithLeftCapWidth(21, topCapHeight: 14)
        
        msgBackgroundView.snp_remakeConstraints { (make) -> Void in
            make.top.equalTo(messagelabel).offset(-5)
            make.bottom.equalTo(messagelabel).offset(10)
            make.left.equalTo(messagelabel).offset(-15)
            make.right.equalTo(messagelabel).offset(15)
        }
    
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 500
    }
    
    //键盘遮挡输入框处理、autoLayout动画
    
    func keyboardWillShow(info: NSNotification){
        let keyboardBounds = info.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue
        inputMessageView.snp_remakeConstraints { (make) -> Void in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view).offset(-Float(keyboardBounds!.height))
            make.height.equalTo(60)
        }
        
        UIView.animateWithDuration(0.5) { () -> Void in
            self.view.layoutIfNeeded()
        }
    
    }
    
    func keyboardWillHide(info: NSNotification){
        inputMessageView.snp_remakeConstraints { (make) -> Void in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
            make.height.equalTo(60)
        }
        UIView.animateWithDuration(0.5) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    
    deinit {
        NSLog("HBChatViewController deinit")
        NSNotificationCenter.defaultCenter().removeObserver(self)
        unreadList.removeAll()
        currentFriendUnreadList.removeAll()
    }
}
