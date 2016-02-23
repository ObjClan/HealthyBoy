//
//  HBChatViewController.swift
//  HealthyBoy
//
//  Created by jszx on 16/2/19.
//  Copyright © 2016年 jszx. All rights reserved.
//


class HBChatViewController: HBBaseViewController,UITableViewDataSource,UITableViewDelegate {
    var historyMessageList = [HBMessage]()        //当前正在聊天的好友所有聊天记录
    var name : String?                           //当前正在聊天的好友
    let tableView = UITableView()
    private let inputTF = UITextField()
    private let inputMessageView = UIView()
    
    override func viewDidLoad() {
        self.navTitle = name!
        super.viewDidLoad()
        
        
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
        if historyMessageList.count > 0 {
            tableView.scrollToRowAtIndexPath(NSIndexPath.init(forRow: historyMessageList.count - 1, inSection: 0), atScrollPosition:UITableViewScrollPosition.Bottom,animated:true)
        }
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name:UIKeyboardWillShowNotification , object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name:UIKeyboardWillHideNotification , object: nil)
    }

    func senBtnClick() {
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.sendMessage(inputTF.text!, fromUser: HBCenterController.sharedInstance().username!, toUser: name!)

        inputTF.text = ""
        inputTF.resignFirstResponder()
        
        let manager = HBHistoryMessageMannager()
    
        historyMessageList = manager.readMessage(name!)
        
        self.tableView.reloadData()
        
        //滚动到表格最后一行
        self.tableView.scrollToRowAtIndexPath(NSIndexPath.init(forRow: historyMessageList.count - 1, inSection: 0), atScrollPosition:UITableViewScrollPosition.Bottom,animated:true)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyMessageList.count
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

            cell?.contentView.addSubview(messageLabel)
            
            let messageBackgroundView = UIImageView()
            messageBackgroundView.tag = 2
            cell?.contentView.addSubview(messageBackgroundView)
            cell?.contentView.sendSubviewToBack(messageBackgroundView)
            
        }
        
        let messagelabel = cell?.contentView.viewWithTag(1) as! UILabel
        messagelabel.backgroundColor = UIColor.clearColor()

        messagelabel.text = historyMessageList[indexPath.row].body
        
        let rect = boundingTextRect(messagelabel, size: CGSizeMake((cell?.contentView.frame.size.width)! * 0.65, CGFloat(MAXFLOAT)))
        
        let iconView = cell?.contentView.viewWithTag(3) as! UIImageView
        
        let msgBackgroundView = cell?.contentView.viewWithTag(2) as! UIImageView
        
        if historyMessageList[indexPath.row].from == name {
            iconView.image = UIImage(named: "xiaohua")
            iconView.snp_remakeConstraints { (make) -> Void in
                make.left.equalTo((cell?.contentView)!).offset(10)
                make.bottom.equalTo(messagelabel).offset(20)
            }
            
            messagelabel.snp_remakeConstraints { (make) -> Void in
                make.top.equalTo((cell?.contentView)!).offset(10)
                make.left.equalTo(iconView.snp_right).offset(20)
                make.height.equalTo(rect.height)
                make.width.lessThanOrEqualTo((cell?.contentView.frame.size.width)! * 0.65)
            }
            
            msgBackgroundView.image = UIImage(named: "yoububble")?.stretchableImageWithLeftCapWidth(21, topCapHeight: 14)
            
        } else {
            iconView.image = UIImage(named: "xiaoming")
            iconView.snp_remakeConstraints { (make) -> Void in
                make.right.equalTo((cell?.contentView)!).offset(-10)
                make.bottom.equalTo(messagelabel).offset(20)
            }
            
            messagelabel.snp_remakeConstraints { (make) -> Void in
                make.top.equalTo((cell?.contentView)!).offset(10)
                make.right.equalTo(iconView.snp_left).offset(-20)
                make.height.equalTo(rect.height)
                make.width.lessThanOrEqualTo((cell?.contentView.frame.size.width)! * 0.65)
            }
            
            msgBackgroundView.image = UIImage(named: "mebubble")?.stretchableImageWithLeftCapWidth(21, topCapHeight: 14)
        }
        
        
        
        msgBackgroundView.snp_remakeConstraints { (make) -> Void in
            make.top.equalTo(messagelabel).offset(-5)
            make.bottom.equalTo(messagelabel).offset(10)
            make.left.equalTo(messagelabel).offset(-20)
            make.right.equalTo(messagelabel).offset(25)
        }
//        messagelabel.backgroundColor = UIColor.redColor()
//        msgBackgroundView.backgroundColor = UIColor.greenColor()
    
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
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
        historyMessageList.removeAll()
    }
}
