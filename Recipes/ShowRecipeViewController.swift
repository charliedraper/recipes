//
//  RecipeViewController.swift
//  Recipes
//
//  Created by Charlie Draper on 7/17/19.
//  Copyright © 2019 Charlie Draper. All rights reserved.
//

import UIKit

class ShowRecipeViewController: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var nameHeader: UINavigationItem!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ingredientsTextView: UITextView!
    
    var recipe: Recipe!
    
    //MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setElements()
    }
 
    //MARK: - Navigation
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let editRecipeViewController = segue.destination as? ModifyRecipeViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        editRecipeViewController.recipe = recipe
    }
    
    //MARK: - Private Methods
    
    private func setElements() {
        nameHeader.title = recipe.name
        photoImageView.image = recipe.image
        dateLabel.text = showDateFormatter.string(from: recipe.date)
        ingredientsTextView.text = recipe.ingredients.replacingOccurrences(of: " -", with: "\n-")
    }
}

//Date formatter for recipe details screen
let showDateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateStyle = .long
    df.timeStyle = .none
    return df
}()
