//
//  Expense+CoreDataProperties.swift
//  sw-expense
//
//  Created by User on 19/4/20.
//  Copyright © 2020 User. All rights reserved.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var name: String?

}
