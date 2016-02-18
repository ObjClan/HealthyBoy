//
//  UserStatusDelegate.swift
//  HealthyBoy
//
//  Created by jszx on 16/2/17.
//  Copyright © 2016年 jszx. All rights reserved.
//

//状态代理
protocol HBUserStatusDelegate {
    func receiveFriendStatus(status : HBUserStatus)
}