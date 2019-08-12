//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Malik Smith on 8/5/19.
//  Copyright © 2019 Malik Smith. All rights reserved.
//

import UIKit
import  CoreData

class ToDoListViewController: UITableViewController {
    
    
    
    var itemArray = [Item] ()
    var selectedCategory : Category? {
        didSet {
            loaditems()
        }
    }
  
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
       print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
       
    
                                                                        
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
        
//         context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
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
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
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
        do {
            try context.save()
         
        } catch {
            print("Error Saving Context \(error)")
           
           
       
            
        }
        self.tableView.reloadData()
    }
    
    func loaditems(with request:NSFetchRequest<Item> = Item.fetchRequest(), predicate:NSPredicate? = nil) {
    
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
     
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }
        else
        {
            request.predicate = categoryPredicate
        }
        
        
        
        
        //  let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate!])
      //  request.predicate = compoundPredicate
        do {
        
        
       itemArray = try context.fetch(request)
        
       }
        catch {
            print("Error Fetching data from context \(error)")
            
        }
        tableView.reloadData()
    
   }
   
}
//Mark:  SearchBar Method

extension ToDoListViewController:UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request:NSFetchRequest<Item> = Item.fetchRequest()
        
       let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
       
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loaditems(with:request, predicate: predicate)
        
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








