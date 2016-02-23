//
//  HBContactsViewController.swift
//  HealthyBoy
//
//  Created by jszx on 16/2/18.
//  Copyright © 2016年 jszx. All rights reserved.
//



class HBContactsViewController: HBBaseViewController,UITableViewDataSource,UITableViewDelegate,HBUserStatusDelegate,HBMessageDelegate {
    
    let tableView = UITableView()
    private let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var userList = NSMutableArray()          //好友列表
    var unreadMessageList = [HBMessage]()    //未读消息
    var toChatFriend : String?               //正在聊天好友

    
    override func viewDidLoad() {
        
        self.navTitle = "联系人"
        self.backBtn.hidden = true
        
        super.viewDidLoad()
        
        let addBtn = UIButton.init(type: UIButtonType.ContactAdd)
        addBtn.addTarget(self, action: "addBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        self.navView.addSubview(addBtn)
        addBtn.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.navView)
            make.right.equalTo(self.navView).offset(-20)
            make.width.height.equalTo(60)
            
        }
        
        self.view.addSubview(tableView)
        
        tableView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.navView.snp_bottom)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        
        userList = appdelegate.userList
        
        tableView.dataSource = self
        tableView.delegate = self
        
        appdelegate.statusDelegate = self
        appdelegate.messageDelegate = self
    }
    
    //添加好友
    func addBtnClick() {
        self.performSegueWithIdentifier("contactsToAdd", sender: self)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let id = "contactsCellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(id)
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: id)
        }
        
        let status = userList[indexPath.row]["status"] as! Bool
        let name = userList[indexPath.row]["name"] as? String
        var unreads = 0 //未读消息条数
        for msg in unreadMessageList {
            if name == msg.from {
                unreads++
            }
        }
        
        cell!.textLabel?.text = name! + "(\(unreads))"
        
        if status == true {
            cell?.detailTextLabel?.text = "在线"
        } else {
            cell?.detailTextLabel?.text = "离线"
        }
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        toChatFriend = userList[indexPath.row]["name"] as? String

        if unreadMessageList.count > 0 {
            //将要从未读消息中删除的下标
            
            var indexList = [Int]()
            
            for index in 0...unreadMessageList.count - 1 {
                let msg = unreadMessageList[index]
                if toChatFriend == msg.from {
                    indexList.append(index)
                }
            }
            
            //下标偏移量
            var deviation = 0
            for index in indexList {
                unreadMessageList.removeAtIndex(index-deviation)
                deviation++
            }
            
            self.tableView.reloadData()
            
            //设置tabbar显示的未读消息条数
            if unreadMessageList.count > 0 {
                self.navigationController?.tabBarItem.badgeValue = "\(unreadMessageList.count)"
            } else {
                self.navigationController?.tabBarItem.badgeValue = nil
            }
        }
    
        self.performSegueWithIdentifier("contactsToChat", sender: self)
        
    }
    
    //收到好友状态改变，刷新数据
    func receiveFriendStatus(status: HBUserStatus) {
        tableView.reloadData()
    }
    
    //收到信息
    func newMsg(aMsg: HBMessage) {

        //如果有正文
        if aMsg.body != "" {
            
            var isChating = false
            
            //如果聊天窗口打开，向当前聊天窗口传递聊天信息,并刷新数据
            var currentChatController : HBChatViewController?
            for controller in (self.navigationController?.childViewControllers)! {
                
                if controller.isKindOfClass(HBChatViewController) {
                    
                    currentChatController = controller as? HBChatViewController
                    
                    let manager = HBHistoryMessageMannager()
                    currentChatController?.historyMessageList = manager.readMessage((currentChatController?.name)!)

                    if aMsg.from == toChatFriend {
                        isChating = true
                    } else {
                        isChating = false
                    }
                    currentChatController?.tableView.reloadData()
                    
                    //滚动到表格最后一行
                    currentChatController?.tableView.scrollToRowAtIndexPath(NSIndexPath.init(forRow: currentChatController!.historyMessageList.count - 1, inSection: 0), atScrollPosition:UITableViewScrollPosition.Bottom,animated:true)
                }
            }
            
            if !isChating {
                unreadMessageList.append(aMsg)
                
                self.navigationController?.tabBarItem.badgeValue = "\(unreadMessageList.count)"
                
                self.tableView.reloadData()
            }
            
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "contactsToChat" {
            let toChatController = segue.destinationViewController as? HBChatViewController
            let manager = HBHistoryMessageMannager()
            toChatController!.historyMessageList = manager.readMessage(toChatFriend!)
            toChatController!.name = toChatFriend
        }
        
        
    }
    deinit {
        NSLog("HBContactsViewController deinit")
    }
}
