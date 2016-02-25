//
//  AppDelegate.swift
//  HealthyBoy
//
//  Created by jszx on 16/2/15.
//  Copyright © 2016年 jszx. All rights reserved.
//

import UIKit
import XMPPFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,XMPPStreamDelegate {

    var window: UIWindow?

    var xmppStream : XMPPStream?
    var isOpen = false
    var pwd = ""
    var userList = NSMutableArray() //好友列表
    
    //状态代理
    weak var statusDelegate: HBUserStatusDelegate?
    
    //消息代理
    weak var messageDelegate: HBMessageDelegate?
    
    //登录结果代理
    weak var loginResultDelegate: HBLoginResultDelegate?
    
    //建立通道
    func buildStream() {
        xmppStream = XMPPStream()
        xmppStream?.addDelegate(self, delegateQueue: dispatch_get_main_queue())
    }
    
    //发送上线状态
    func goOnline() {
        let presence = XMPPPresence()
        xmppStream?.sendElement(presence)
    }
    
    //发送下线状态
    func goOffline() {
        let presence = XMPPPresence(type: "unavailabe")
        xmppStream?.sendElement(presence)
    }
    
    //当前用户是否在线
    func isOnLine()->Bool {
        return (xmppStream?.isConnected())!
    }
    
    func sendMessage(msg: String, fromUser: String,toUser: String) {
        //XMPPFramework主要是通过KissXML来生成XML文件
        //生成<body>文档
        let body:DDXMLElement = DDXMLElement.elementWithName("body") as! DDXMLElement
        body.setStringValue(msg)
        
        //生成XML消息文档
        let mes:DDXMLElement = DDXMLElement.elementWithName("message")as! DDXMLElement
        //消息类型
        mes.addAttributeWithName("type",stringValue:"chat")
        //发送给谁
        mes.addAttributeWithName("to" ,stringValue:toUser)
    
        //由谁发送
        mes.addAttributeWithName("from" ,stringValue:fromUser)
        //组合
        mes.addChild(body)
        
        let sendTime:DDXMLElement = DDXMLElement.elementWithName("sendTime") as! DDXMLElement
        sendTime.setStringValue("\(NSDate().timeIntervalSince1970)")
        mes.addChild(sendTime)
        //发送消息
        self.xmppStream?.sendElement(mes)
        
        //保存消息
        let manager = HBHistoryMessageMannager()
        var msgModel = HBMessage()
        
        msgModel.from = fromUser
        msgModel.to = toUser
        msgModel.body = msg
        msgModel.sendTime = sendTime.stringValue()
        manager.addMessage(msgModel)
    }
    
    //链接服务器(查看服务器是否可连接)
    func connect(user : String!,password : String!) ->Bool {
        buildStream()
        //通道已连接
        if xmppStream!.isConnected() {
            return true
        }
        
        xmppStream?.myJID = XMPPJID.jidWithString(user)
        xmppStream?.hostName = HBCenterController.sharedInstance().hostName
        
        do {
            try xmppStream?.connectWithTimeout(20)
        } catch {
           print(error)
            self.loginResultDelegate?.loginResult(1, message: "连接失败")
        }
        
        pwd = password
        
        return false
    }
    

    //断开连接
    func disConnect() {
        if xmppStream != nil && xmppStream!.isConnected() {
            goOffline()
            xmppStream?.disconnect()
        }
        
    }
    

    
    //连接成功
    func xmppStreamDidConnect(sender: XMPPStream!) {
        NSLog("服务器连接成功")
        isOpen = true
        do {
            //密码验证
            try xmppStream?.authenticateWithPassword(pwd)
        } catch {
            print(error)
        }
    }
    
    //连接失败
    func xmppStreamDidDisconnect(sender: XMPPStream!, withError error: NSError!) {
        var message: String?
        if error.code == 51 || error.code == 57 {
            message = "连接失败，请检查网络连接"
        } else if error.code == 7 {
            message = "连接失败，sroket断开"
        } else {
            message = "连接失败，未知错误"
        }
        self.loginResultDelegate?.loginResult(1, message: message!)
    }
    
    //连接超时
    func xmppStreamConnectDidTimeout(sender: XMPPStream!) {
        self.loginResultDelegate?.loginResult(1, message: "连接超时")
    }
    
    //验证成功
    func xmppStreamDidAuthenticate(sender: XMPPStream!) {
        NSLog("验证成功")
        
        self.loginResultDelegate?.loginResult(0, message: "success")
        //上线
        goOnline()
        
    }
    
    //验证失败
    func xmppStream(sender: XMPPStream!, didNotAuthenticate error: DDXMLElement!) {
        self.loginResultDelegate?.loginResult(1, message: "验证失败,用户名或密码错误")
    }

    
    //收到状态
    func xmppStream(sender: XMPPStream!, didReceivePresence presence: XMPPPresence!) {
        
        print("账号:\(presence.from().user),type:\(presence.type())")
        
        //我自己的用户名
        let myUser = sender.myJID.user
        
        //好友的用户名
        let user = presence.from().user
        
        //用户所在的域
        let domain = presence.from().domain
        
        //状态类型
        let pType = presence.type()
        
        //如果状态不是自己的
        if (user != myUser) {
           
            //保存状态
            var status = HBUserStatus()
            status.name = user + "@" + domain
            
            //好友上线
            if pType == "available" {
                status.isOnline = true
                for dict in userList {
                    if dict["name"] as! String == status.name {
                        if dict["status"] as! Bool == true {
                            return
                        } else {
                            userList.removeObject(dict)
                        }
                    }
                }
                let userDict = ["name" : status.name, "status" : status.isOnline]
                userList.addObject(userDict)
                
                
            //下线
            } else if pType == "unavailable" {
                status.isOnline = false
                for dict in userList {
                    if dict["name"] as! String == status.name {
                        if dict["status"] as! Bool == false {
                            return
                        } else {
                            userList.removeObject(dict)
                        }
                        
                    }
                }
                let userDict = ["name" : status.name, "status" : status.isOnline]
                userList.addObject(userDict)
            }
            //将好友上线状态添加到代理中
            statusDelegate!.receiveFriendStatus(status)
        }

    }
    
    func xmppStream(sender: XMPPStream!, didReceiveIQ iq: XMPPIQ!) -> Bool {
        return true
    }
    
    //收到消息
    func xmppStream(sender: XMPPStream!, didReceiveMessage message: XMPPMessage!) {
        //如果是聊天消息（收到的消息可能是语言、视频、聊天等）
        if message.isChatMessage() {
            var msg = HBMessage()
            
            if message.elementForName("composing") != nil {
                msg.isComposing = true
            }
            
            //离线消息
            if message.elementForName("delay") != nil {
                msg.isDelay = true
            }
            
            //消息正文
            if let body = message.elementForName("body") {
                msg.body = body.stringValue()
            }
            
            msg.from = message.from().user + "@" + message.from().domain
            msg.to = message.to().user + "@" + message.to().domain
            
            if message.elementForName("sendTime") != nil {
                msg.sendTime = message.elementForName("sendTime").stringValue()
            }
            
            //保存消息
            let manager = HBHistoryMessageMannager()
            manager.addMessage(msg)
            
            //添加到消息代理中
            messageDelegate?.newMsg(msg)
            
        }
    }
    
    
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

