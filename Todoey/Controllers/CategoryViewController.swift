//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Johnny Moore on 10/15/18.
//  Copyright © 2018 jmopolis. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var catArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCats()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textfield.text!
            self.catArray.append(newCategory)
            self.saveCats()
        }
        alert.addTextField { (field) in
            field.placeholder = "Add new category name"
            textfield = field
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let cat = catArray[indexPath.row]
        
        cell.textLabel?.text = cat.name
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = catArray[indexPath.row]
        }
        
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveCats() {
        do {
            try context.save()
        } catch {
            print("Error saving from context, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCats(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            catArray = try context.fetch(request)
        } catch {
            print("Error loading from context, \(error)")
        }
        tableView.reloadData()
    }
}
