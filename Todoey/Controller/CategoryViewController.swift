//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Malik Smith on 8/10/19.
//  Copyright © 2019 Malik Smith. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework



class CategoryViewController: SwipeTableViewController  {
    
    
    let realm = try! Realm()
    var categories: Results<Category>?
  
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       loadcategories()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
         print(Realm.Configuration.defaultConfiguration.fileURL!)
       
   
    
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }
    

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row] {
       
        cell.textLabel?.text = category.name
        cell.backgroundColor = UIColor(hexString: category.color)
        
            guard let categoryColor = UIColor(hexString: category.color) else {fatalError()}
        cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: categoryColor, isFlat: true)
        
      
        
        //Ternary Operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        

        }
    
      
        
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField ()

       
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in 
        
        
        //Mark:- TableViewDatasource Methods
        
            let newCategory = Category()
        newCategory.name = textField.text!
            newCategory.color = (UIColor.randomFlat.hexValue())
            self.saveCategories(category: newCategory)
       
        
        
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
        
        
        //Mark: - Data Manipulation Methods
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    realm.delete(categoryForDeletion)
                }
                
            }
            catch {
               print("Error Deleting Category, \(error)")
            }
        }
    }
    
    func saveCategories (category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
            
        } catch {
            print("Error Saving Context \(error)")
            
            
            
            
        }
        self.tableView.reloadData()
    }
    func loadcategories() {
        categories = realm.objects(Category.self)

        tableView.reloadData()
        
    }

}








