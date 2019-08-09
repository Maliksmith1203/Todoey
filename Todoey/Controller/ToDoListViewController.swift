//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Malik Smith on 8/5/19.
//  Copyright © 2019 Malik Smith. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
       let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    
    var itemArray = [item] ()
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loaditems()
        
                                                                        
    }    // Do any additional setup after loading the view.
    
    
    //Mark - TableView DataSource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
       //Ternary Operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done  ? .checkmark : .none
        
     
       
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    
        saveItems()

        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    //Mark- Add new Items
    
    

    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen Once the user clicks the add button item on our UIAlert
            let newItem = item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            self.saveItems()
            
           
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
       
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
       
    }
    
    
    func saveItems () {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to:dataFilePath!)
        } catch {
            
            print("error")
            
        }
        self.tableView.reloadData()
    }
    
    func loaditems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                
            itemArray = try decoder.decode([item].self, from: data)
            }
            catch {
                print("error")
            }
            
        }
        
    }
}

