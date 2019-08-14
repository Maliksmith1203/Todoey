//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Malik Smith on 8/10/19.
//  Copyright © 2019 Malik Smith. All rights reserved.
//

import UIKit
import RealmSwift



class CategoryViewController: UITableViewController  {
    
    
    let realm = try! Realm()
    
    
    var categories: Results<Category>?
    override func viewDidLoad() {
        super.viewDidLoad()
       loadcategories()
    
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categories?[indexPath.row].name ?? "No Categories added yet"
        cell.textLabel?.text = category
        
        //Ternary Operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        

        
        
        
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
