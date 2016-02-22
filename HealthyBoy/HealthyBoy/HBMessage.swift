//
//  HBMessage.swift
//  HealthyBoy
//
//  Created by jszx on 16/2/17.
//  Copyright © 2016年 jszx. All rights reserved.
//

//消息结构
struct HBMessage {
    var sendTime = ""
    var body = ""
    var from = ""
    var isComposing = false  //正在输入
    var isDelay = false     //离线
    var isMe = false        //自己的
}

//状态结构
struct HBUserStatus {
    var name = ""
    var isOnline = false
}
