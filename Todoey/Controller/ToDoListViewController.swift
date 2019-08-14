//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Malik Smith on 8/5/19.
//  Copyright © 2019 Malik Smith. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    
    
    var toDoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet {
            loaditems()
        }
    }
  
   

    override func viewDidLoad() {
        super.viewDidLoad()
     print(Realm.Configuration.defaultConfiguration.fileURL!)
       
    
                                                                        
    }    // Do any additional setup after loading the view.
    
    
    //Mark - TableView DataSource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)
        
        if let items = toDoItems?[indexPath.row] {
            
                cell.textLabel?.text = items.title
                 cell.accessoryType = items.done  ? .checkmark : .none
            
        }
        else {
            print("No items added")
        }
        
       //Ternary Operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        
//        cell.accessoryType = toDoItems.done  ? .checkmark : .none
        
     
       
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//         context.delete(toDoItems[indexPath.row])
//        toDoItems.remove(at: indexPath.row)
        
        if let item = toDoItems?[indexPath.row]  {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
    

        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    //Mark- Add new Items
    
    

    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen Once the user clicks the add button item on our UIAlert
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                    
                } catch {
                    print("Error Saving Context \(error)")
                }
            
                
            }
            self.tableView.reloadData()
    
            
            
            
           
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
       
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
       
    }
    
  
    
    func loaditems() {
     toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
  
        tableView.reloadData()

   }

}
// Mark:  SearchBar Method

extension ToDoListViewController:UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
tableView.reloadData()
     }


    func searchBar(_ searchBar:UISearchBar, textDidChange searchText:String) {

        if searchBar.text?.count == 0 {
            loaditems()
            DispatchQueue.main.async {
        searchBar.resignFirstResponder()

            }
        }

    }
}












