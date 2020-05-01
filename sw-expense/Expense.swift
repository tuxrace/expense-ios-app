//
//  Expense.swift
//  sw-expense
//
//  Created by User on 1/5/20.
//  Copyright © 2020 User. All rights reserved.
//

import UIKit

class Expenses {
    var amount: Float
    var date: Date
    
    init(amount: Float, date: Date){
        self.amount = amount
        self.date = date
    }
}
