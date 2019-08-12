//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Malik Smith on 8/10/19.
//  Copyright © 2019 Malik Smith. All rights reserved.
//

import UIKit
import CoreData



class CategoryViewController: UITableViewController  {
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
     var categoryArray = [Category] ()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadcategories()
    
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        
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
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField ()
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in 
        
        
        //Mark:- TableViewDatasource Methods
        
        let newCategory = Category(context:self.context)
        newCategory.name = textField.text
            self.categoryArray.append(newCategory)
            self.saveCategories()
       
        
        
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
        
        
        //Mark: - Data Manipulation Methods
    }
    
    func saveCategories () {
        do {
            try context.save()
            
        } catch {
            print("Error Saving Context \(error)")
            
            
            
            
        }
        self.tableView.reloadData()
    }
    func loadcategories(with request:NSFetchRequest<Category> = Category.fetchRequest()) {
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            
            
            categoryArray = try context.fetch(request)
            
        }
        catch {
            print("Error Fetching data from context \(error)")
            
        }
        tableView.reloadData()
        
    }
}
