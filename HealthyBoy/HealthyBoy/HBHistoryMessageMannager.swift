//
//  HBHistoryMessageMannager.swift
//  HealthyBoy
//
//  Created by jszx on 16/2/23.
//  Copyright © 2016年 jszx. All rights reserved.
//
import CoreData
class HBHistoryMessageMannager {
    var _context: NSManagedObjectContext?
    var context: NSManagedObjectContext?{
        set {
            _context = newValue
        }
        get {
            if _context == nil {
                _context = NSManagedObjectContext()
                let model = NSManagedObjectModel.init(contentsOfURL: NSBundle.mainBundle().URLForResource("HBCoreModel", withExtension: "momd")!)
                let store = NSPersistentStoreCoordinator.init(managedObjectModel: model!)
                let doc = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
                let sqlitePath = doc + "/HBHistoryMessage.sqlite"
                try! store.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: NSURL.fileURLWithPath(sqlitePath), options: nil)
                _context?.persistentStoreCoordinator = store
                
            }
            return _context
        }
    }
    
    //保存信息
    func addMessage(msg : HBMessage) {
        let message = NSEntityDescription.insertNewObjectForEntityForName("HBHistoryMessage", inManagedObjectContext: self.context!) as! HBHistoryMessage
        message.from = msg.from
        message.to = msg.to
        message.body = msg.body
        message.sendTime = msg.sendTime
        try!self.context?.save()
    }
    //获取信息
    func readMessage(username : String)->[HBMessage] {
        let request = NSFetchRequest.init(entityName: "HBHistoryMessage")
        
        //设置过滤条件
        let predicate = NSPredicate.init(format: "from = %@ or to = %@", username,username)
        request.predicate = predicate
        
        //设置排序，以发送时间升序排序。
        let timeSort = NSSortDescriptor.init(key: "sendTime", ascending: true)
        request.sortDescriptors = [timeSort]
        var messagesList = []
        try! messagesList = (self.context?.executeFetchRequest(request))!
        var resultMessageList = [HBMessage]()
        if messagesList.count > 0 {
            for index in 0...messagesList.count - 1 {
                let msg = messagesList[index] as! HBHistoryMessage
                var message = HBMessage()
                message.from = msg.from!
                message.to = msg.to!
                message.body = msg.body!
                message.sendTime = msg.sendTime!
                resultMessageList.append(message)
//                NSLog("from: " + msg.from! + "," + "to: " + msg.to! + "," + "time: " + msg.sendTime! + "," + "body: " + msg.body!)
            }
        }
        
        return resultMessageList
    }
}
