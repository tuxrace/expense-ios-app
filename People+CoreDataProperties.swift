//
//  People+CoreDataProperties.swift
//  sw-people
//
//  Created by User on 19/4/20.
//  Copyright © 2020 User. All rights reserved.
//
//

import Foundation
import CoreData


extension People {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<People> {
        return NSFetchRequest<People>(entityName: "People")
    }

    @NSManaged public var name: String?

}
