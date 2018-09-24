//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Juan Mejia on 9/19/18.
//  Copyright © 2018 Juan Mejia. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
import SVProgressHUD

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    let colorArray = ["6ABB72", "3ABB9D", "4DA664", "2CA786",
                      "5CADCF", "3585C5", "4590B6", "2F6CAD", "485675", "29334D",
                      "9069B5", "533D7F",
                      "F2D46F", "F7C23E",
                      "F79E3D", "EE7841",
                      "E66B5B", "CC4846", "DC5047", "B33234"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateNavBar(withHexcode: FlatWhite().hexValue())
        loadCategories()
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row]{
            
            cell.textLabel?.text = category.name 
            
            guard let categoryColor = UIColor(hexString: category.color) else {fatalError()}
            
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self).sorted(byKeyPath: "name", ascending: true)
        
        tableView.reloadData()

    }
    
    //Mark: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion.items)
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
            
        }

    }
    
    //MARK: - Add New Categories
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        let add = UIAlertAction(title: "Add", style: .default) { (action) in
            
            //Appends new category to array and reloads the table view with new array data
            
            let newCategory = Category()
            let random = Int(arc4random_uniform(20))
            
            if !(textField.text?.isEmpty)! {
                newCategory.name = textField.text!
                newCategory.color = self.colorArray[random]
            
                self.save(category: newCategory)
            }
            else {
                SVProgressHUD.showError(withStatus: "Please add category name")
                SVProgressHUD.dismiss(withDelay: 1)
            }
        }
        
        alert.addAction(cancel)
        alert.addAction(add)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
    
        present(alert, animated: true, completion: nil)
    
    }
    
    // MARK - Nav Bar Setup Methods
    
    func updateNavBar(withHexcode colorHexCode:String) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist.")}
        
        guard let navBarColor = UIColor(hexString: colorHexCode) else {fatalError()}
        
        navBar.barTintColor = navBarColor
        
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
    }
    
}


