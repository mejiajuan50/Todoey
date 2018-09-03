//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Juan Mejia on 9/2/18.
//  Copyright © 2018 Juan Mejia. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        print(dataFilePath)
        
        loadItems()
        
    }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary operator ==>
        // value = condition ? valueIfTrue : ValueIfFalse
        
        cell.accessoryType = item.done   ? .checkmark : .none
        
        return cell
    }
    
    
    
    // MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Set done property to the opposite of its bool value to add/remove check when selected
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()

        //Unhighlights the cell selected
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //Appends new item to array and reloads the table view with new array data
            let newItem = Item()
            
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
    
    //Mark - Model Manupulation Methods
    
    func saveItems() {
        
        //Use swift encoder to encode data onto a plist
        let encoder = PropertyListEncoder()
        
        do{
            let data =  try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch{
            print("Error encoding item array, \(error)")
            
        }
        
        tableView.reloadData()
        
    }
    
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
    
}


