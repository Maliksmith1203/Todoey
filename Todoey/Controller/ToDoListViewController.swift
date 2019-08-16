//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Malik Smith on 8/5/19.
//  Copyright © 2019 Malik Smith. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class ToDoListViewController: SwipeTableViewController {
    
    
  
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    var toDoItems: Results<Item>?

    let realm = try! Realm()
    var selectedCategory : Category?
    {
        didSet {
            loaditems()
        }
    }
    
    
   
  
   

    override func viewDidLoad() {
        super.viewDidLoad()
      
        tableView.rowHeight = 80.0
       
    
                                                                        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectedCategory?.color {
           title = selectedCategory!.name
            updateNavBar(withHexCode: colorHex)
            
      
            }
        }
    
    
    override func viewWillDisappear(_ animated: Bool) {

       updateNavBar(withHexCode: "1D9Bf6")
    }
    
    
    func updateNavBar(withHexCode colorHexCode:String) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller Does Not Exist")}
        if let navBarColor = UIColor(hexString: colorHexCode) {
            navBar.barTintColor = navBarColor
            navBar.tintColor = UIColor(contrastingBlackOrWhiteColorOn:navBarColor, isFlat:true)
            navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(contrastingBlackOrWhiteColorOn:navBarColor, isFlat:true)]
            searchBar.barTintColor = navBarColor
        }
    }
    

    
        
          
            
    
    // Do any additional setup after loading the view.
    
    
    // MARK: Table DataSource Methods
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let items = toDoItems?[indexPath.row] {
            
                cell.textLabel?.text = items.title
                 cell.accessoryType = items.done ? .checkmark : .none
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) /  CGFloat(toDoItems!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn:color, isFlat:true)

            }
            
        }
        else {
            cell.textLabel?.text = "No Items Added"
            
        }
        
       //Ternary Operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        
//        cell.accessoryType = toDoItems.done  ? .checkmark : .none
        
     
       
        return cell
        
    }
    override func updateModel(at indexPath: IndexPath) {
        
        if let itemForDeletion = self.toDoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    realm.delete(itemForDeletion)
                }
                
            }
            catch {
                print("Error Deleting Category, \(error)")
            }
        }
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
            tableView.reloadData()
            
        }
       

        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
  // MARK:Add New Items
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
// MARK: Searchbar Method


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












