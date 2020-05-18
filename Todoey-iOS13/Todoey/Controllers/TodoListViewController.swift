//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController{

    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory: Category? {
        didSet{
           loadItems()
        }
    }
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        }
    

    override func viewWillAppear(_ animated: Bool) {
        if let color = selectedCategory?.backgroundColor{
           
            title = selectedCategory?.name
            guard let navBar = navigationController?.navigationBar else{
                fatalError("Navigation Controller does not exist.")
            }
            searchBar.barTintColor = UIColor(hexString: color)
            
            let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as! UITextField
            
    
            navBar.barTintColor = UIColor(hexString: color)
            if let navBarColor = UIColor(hexString: color){
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
                navBar.isTranslucent = false
                navBar.backgroundColor = navBarColor
                textFieldInsideSearchBar.textColor = ContrastColorOf(navBarColor, returnFlat: true)
            }
            
            
        }
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
    
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory{
                do  {
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }
            catch {
                print("Error saving new items: \(error)")
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

    
//MARK: - tableView Data sources
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return todoItems?.count ?? 1
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = super.tableView(tableView, cellForRowAt: indexPath)
            
            if let item = todoItems?[indexPath.row] {
                cell.textLabel?.text = item.title
                let categoryBackgroundColor = UIColor(hexString: (selectedCategory?.backgroundColor)!)
                
                if let color = categoryBackgroundColor?.darken(byPercentage:
                    CGFloat(indexPath.row)*0.7 / CGFloat(todoItems!.count)
                    ){
                    cell.backgroundColor = color
                    cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                    cell.tintColor = ContrastColorOf(color, returnFlat: true)
                    
                }

                // Ternary operator ==>
                // value = condition ? valueIfTrue : valueIfFalse
                cell.accessoryType = item.done ? .checkmark : .none
                
            } else{
                cell.textLabel?.text = "No Items Added"
            }
            return cell
        }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if let item = todoItems?[indexPath.row]{
                do{
                    try realm.write{
                        item.done = !item.done
                    }
                } catch{
                    print("Error saving done status: \(error)")
                }
            }
            tableView.reloadData()
            tableView.deselectRow(at: indexPath, animated: true)
            
        }
    //MARK: - CoreData Manipulation Functions
    
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        //super.updateModel(at: indexPath)
        deleteItem(at: indexPath)
    }
    
    func deleteItem(at indexPath: IndexPath){
        
        if let itemforDelete = todoItems?[indexPath.row]{
            do{
                try realm.write{
                    realm.delete(itemforDelete)
                }
            } catch{
                print("Item couldn't be deleted: \(error)")
            }
        }
    }

}

//MARK: - UISearchBarDelegate
extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    
}
