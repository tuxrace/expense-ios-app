//
//  ViewController.swift
//  sw-expense
//
//  Created by User on 19/4/20.
//  Copyright © 2020 User. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var labelExpenses: UILabel!
    @IBOutlet weak var textAmount: UITextField!
    @IBOutlet weak var testTable: UITableView!
    var expenses: [Float] = [];
    override func viewDidLoad() {
        deleteData()
        getData()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.addDoneButtonOnKeyboard()
        testTable.dataSource = self
        testTable.delegate = self
        
    }
    
    func addDoneButtonOnKeyboard()
    {
        let toolBar =  UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
       toolBar.barStyle = .default
       toolBar.sizeToFit()

       // Adding Button ToolBar
       let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
        
       // add to toolbar items
       toolBar.items = [doneButton]
       toolBar.isUserInteractionEnabled = true
       textAmount.inputAccessoryView = toolBar
    }
    
    @objc func doneButtonTapped(sender: UIBarButtonItem) {
        if (textAmount.text != ""){
            saveAmount(Float(textAmount.text!)!)
        }
        textAmount.text = ""
        textAmount.resignFirstResponder()
    }
    
    func saveAmount(_ amt: Float){
        // CoreData
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Expense", in: context)
        let expenseData = NSManagedObject(entity: entity!, insertInto: context)
        expenseData.setValue(amt, forKey: "amount")
        do {
            try context.save()
            expenses.insert(amt, at: expenses.endIndex)
        } catch  {
            print("fail")
        }
        
        // Table
        let indexPath = IndexPath(row: expenses.count - 1, section: 0)
        testTable.beginUpdates()
        testTable.insertRows(at: [indexPath], with: .automatic)
        testTable.endUpdates()
        
        // Label
        updatedExpense()
    }
    
    func getData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Expense")
        request.returnsObjectsAsFaults = false
        
        do {
            let res = try context.fetch(request)
            if (res.count > 0){
                for x in res as! [NSManagedObject]{
                    expenses.insert(x.value(forKey: "amount") as! Float, at: expenses.endIndex)
                }
            }
        } catch  {
            print("fail")
        }
    }
    
    func updatedExpense(){
        let expensesTotal = expenses.reduce(0, +)
        if (expensesTotal > 250 && expensesTotal < 400){
            labelExpenses.backgroundColor = UIColor.orange
        } else if(expensesTotal > 400){
            labelExpenses.backgroundColor = UIColor.red
        }
        labelExpenses.text = String(expenses.reduce(0, +))
    }
    
    func deleteData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Expense")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(deleteRequest)
        } catch  {
            print("fail")
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        expenses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = String(expenses[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}
