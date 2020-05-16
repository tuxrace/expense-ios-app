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
    var expenses: [Expenses] = [];
    override func viewDidLoad() {
        deleteData()
        getData()
        self.view.backgroundColor = .red
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.addDoneButtonOnKeyboard()
        testTable.dataSource = self
        testTable.delegate = self
        self.navigationItem.title = "Expenses"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
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
        // Save to CoreData
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Expense", in: context)
        let expenseData = NSManagedObject(entity: entity!, insertInto: context)
        let todayDate = Date()
        expenseData.setValue(amt, forKey: "amount")
        expenseData.setValue(todayDate, forKey: "date")
        
        do {
            try context.save()
            let today = Date()
            let expensesInfo = Expenses(amount: amt, date: today)
            expenses.insert(expensesInfo, at: expenses.endIndex)
        } catch  {
            print("fail")
        }
        
        // Update Table
        let indexPath = IndexPath(row: expenses.count - 1, section: 0)
        testTable.beginUpdates()
        testTable.insertRows(at: [indexPath], with: .automatic)
        testTable.endUpdates()
        
        // Update Label
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
                    let expensesInfo = Expenses(amount: x.value(forKey: "amount") as! Float, date: x.value(forKey: "date") as! Date)
                    expenses.insert(expensesInfo, at: expenses.endIndex)
                }
            }
        } catch  {
            print("fail")
        }
    }
    
    func updatedExpense(){
        let amountExpenses: [Float] = expenses.map({ return $0.amount })
        let expensesTotal = amountExpenses.reduce(0, +)
        if (expensesTotal > 250 && expensesTotal < 400){
            labelExpenses.backgroundColor = UIColor.orange
        } else if(expensesTotal > 400){
            labelExpenses.backgroundColor = UIColor.red
        }
        labelExpenses.text = String(expensesTotal)
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
        
        let date = expenses[indexPath.row].date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM-dd-yyyy"
        let dateString = dateFormatter.string(from: date)
        
        cell.textLabel?.text = String(expenses[indexPath.row].amount)
        cell.detailTextLabel?.textColor = .lightGray
        cell.detailTextLabel?.text = dateString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
//    func deleteAction(indexPath) -> UIContextualAction {
//        let selected = expenses[indexPath];
//        let action = UIContextualAction(style: .normal, title: 'delete', handler: {
//
//        })
//    }
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let delete = deleteAction(indexPath)
//        return UISwipeActionsConfiguration(actions: [delete])
//    }
    
}
