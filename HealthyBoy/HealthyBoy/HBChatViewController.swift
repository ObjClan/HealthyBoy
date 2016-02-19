//
//  HBChatViewController.swift
//  HealthyBoy
//
//  Created by jszx on 16/2/19.
//  Copyright © 2016年 jszx. All rights reserved.
//

class HBChatViewController: HBBaseViewController,UITableViewDataSource,UITableViewDelegate {
    var unreadList = [HBMessage]()
    var currentFriendUnreadList = [HBMessage]()
    var name : String?
    let tableView = UITableView()
    let inputTF = UITextField()
    
    override func viewDidLoad() {
        self.navTitle = name!
        super.viewDidLoad()
        
        for msg in unreadList {
            if msg.from == name {
                currentFriendUnreadList.append(msg)
            }
        }
        
        self.view.addSubview(tableView)
        tableView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.navView.snp_bottom)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let inputMessageView = UIView()
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
        sendBtn.backgroundColor = UIColor.redColor()
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
    }
    
    func senBtnClick() {
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.sendMessage(inputTF.text!, fromUser: HBCenterController.sharedInstance().username!, toUser: name!)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentFriendUnreadList.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let id = "chatCellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(id)
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: id)
        }
        cell?.textLabel?.text = currentFriendUnreadList[indexPath.row].body
        return cell!
    }
    

    
    deinit {
        NSLog("HBChatViewController deinit")
    }
}
