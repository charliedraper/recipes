//
//  RecipesTableViewController.swift
//  Recipes
//
//  Created by Charlie Draper on 7/17/19.
//  Copyright © 2019 Charlie Draper. All rights reserved.
//

import UIKit

class RecipeTableViewController: UITableViewController {
    
    //MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Edit button
        navigationItem.leftBarButtonItem = editButtonItem
        
        //Initialize recipes from the disk
        if let savedRecipes = loadRecipes() {
            recipes += savedRecipes
            //recipes.sort()
        }
    }

    // MARK: - Table view data source

    //Single section with rows equal to the size of the array
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }

    //Display contents of each row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =
            tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as? RecipeTableViewCell else {
            fatalError("Dequed cell is not an example of a Recipe Cell")
        }
        let recipe = recipes[indexPath.row]
        return generate(cell, from: recipe)
    }
    
    //Enables the edit mode feature of the table view
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    //Supports deleting recipes in edit mode
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            recipes.remove(at: indexPath.row)
            saveRecipes()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    
    //Pass the selected recipe to the RecipeViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navVC = segue.destination as? UINavigationController
        if segue.identifier == "PresentRecipe" {
            let presentVC = navVC?.topViewController as! ShowRecipeViewController
            presentVC.recipe = recipes[tableView.indexPathForSelectedRow!.row]
        }
    }
    
    //MARK: - Actions
    
    //When a new recipe is saved, add it to the table view
    @IBAction func unwindToRecipeList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ModifyRecipeViewController, let recipe = sourceViewController.recipe {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                recipes[selectedIndexPath.row] = recipe
            } else {
                recipes.append(recipe)
            }
            
            recipes.sort { $0 > $1 }
            tableView.reloadData()
            saveRecipes()
        }
    }
    
    //MARK: - Private Functions
    
    //Temporary function to start with an array
    private func loadSampleRecipes() {
        recipes = [
            Recipe(name: "Grilled Cheese", ingredients: "bread^cheese", date: Date(timeIntervalSinceNow: 0), image: UIImage(named: "defaultPhoto")!)
        ]
    }
    
    private func generate(_ cell: RecipeTableViewCell, from recipe: Recipe) -> RecipeTableViewCell {
        cell.nameLabel.text = recipe.name
        cell.dateLabel.text = cellDateFormatter.string(from: recipe.date)
        cell.photoImageView.image = recipe.image
        return cell
    }
    
    //Store recipes on the disk
    private func saveRecipes() {
        let dataPath = URL(fileURLWithPath: Recipe.ArchiveURL.path)
        let codedData = try! NSKeyedArchiver.archivedData(withRootObject: recipes, requiringSecureCoding: false)
        do {
            try codedData.write(to: dataPath)
        } catch {
            print("Couldn't write to save file")
        }
    }
    
    //Load recipes from the disk
    private func loadRecipes() -> [Recipe]? {
        let dataPath = URL(fileURLWithPath: Recipe.ArchiveURL.path)
        guard let codedData = try? Data(contentsOf: dataPath) else { return nil }
        return try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(codedData) as? [Recipe]
    }
}

//Date formatter for table view cells
let cellDateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateStyle = .short
    df.timeStyle = .none
    return df
}()
