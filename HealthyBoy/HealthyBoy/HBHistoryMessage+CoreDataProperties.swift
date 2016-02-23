//
//  HBHistoryMessage+CoreDataProperties.swift
//  HealthyBoy
//
//  Created by jszx on 16/2/23.
//  Copyright © 2016年 jszx. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension HBHistoryMessage {

    @NSManaged var from: String?
    @NSManaged var to: String?
    @NSManaged var body: String?
    @NSManaged var sendTime: String?

}
