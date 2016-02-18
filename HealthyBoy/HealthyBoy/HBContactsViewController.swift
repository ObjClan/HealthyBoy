//
//  HBContactsViewController.swift
//  HealthyBoy
//
//  Created by jszx on 16/2/18.
//  Copyright © 2016年 jszx. All rights reserved.
//



class HBContactsViewController: HBBaseViewController,UITableViewDataSource,UITableViewDelegate,HBUserStatusDelegate,HBMessageDelegate {
    
    let tableView = UITableView()
    let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var userList = NSMutableArray()
    var unreadMessageList = [HBMessage]()
    
    
    override func viewDidLoad() {
        
        self.navTitle = "联系人"
        self.backBtn.hidden = true
        
        super.viewDidLoad()
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
        self.navigationController?.tabBarItem.badgeValue = nil
        
    }
    
    //收到好友状态改变，刷新数据
    func receiveFriendStatus(status: HBUserStatus) {
        tableView.reloadData()
    }
    
    //收到信息
    func newMsg(aMsg: HBMessage) {
        self.navigationController?.tabBarItem.badgeValue = "new"
        //如果有正文
        if aMsg.body != "" {
            unreadMessageList.append(aMsg)
            self.tableView.reloadData()
        }
    }
    
    deinit {
        NSLog("HBContactsViewController deinit")
    }
}
