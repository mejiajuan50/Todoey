//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Juan Mejia on 9/19/18.
//  Copyright © 2018 Juan Mejia. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadCategories()
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name

        return cell
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func saveCategories() {
        
        do{
            try context.save()
        }
        catch{
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categories = try context.fetch(request)
        }
        catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    //MARK: - Add New Categories
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        let add = UIAlertAction(title: "Add", style: .default) { (action) in
            
            //Appends new category to array and reloads the table view with new array data
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!

            
            self.categories.append(newCategory)
            
            self.saveCategories()
            
        }
        
        alert.addAction(cancel)
        alert.addAction(add)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
    
        present(alert, animated: true, completion: nil)
    
    }
    
    //MARK: - TableView Delegate Methods
    
    
    
}
