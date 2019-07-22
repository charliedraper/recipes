//
//  AddRecipeViewController.swift
//  Recipes
//
//  Created by Charlie Draper on 7/18/19.
//  Copyright © 2019 Charlie Draper. All rights reserved.
//

import UIKit

class ModifyRecipeViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ingredientsTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var recipe: Recipe?
    
    //MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Assign delegates
        nameTextField.delegate = self
        ingredientsTextField.delegate = self
        
        //Load the current recipe if editing
        if let recipe = recipe {
            loadData(for: recipe)
        }
        
        //Update the save button state
        updateSaveButtonState()
    }

    // MARK: - Navigation

    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //Append a new recipe when the save button is pressed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else { return }
        createRecipe()
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Disable the save button when editing a text field
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
    //MARK: - UIImagePickerControllerDelegate
    
    //Run when the cancel button is selected
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //Run when a photo is selected
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was presented with the following: \(info)")
        }
        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Actions
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UIButton) {
        //Hide the keyboards
        nameTextField.resignFirstResponder()
        ingredientsTextField.resignFirstResponder()
        
        //Select and present the chosen image
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: - Private Methods
    
    private func updateSaveButtonState() {
        //Enable the save button if text has been entered into the name field
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    private func loadData(for recipe: Recipe) {
        navigationItem.title = "Edit Recipe"
        nameTextField.text = recipe.name
        ingredientsTextField.text = recipe.ingredients
        datePicker.date = recipe.date
        photoImageView.image = recipe.image
    }
    
    private func createRecipe() {
        let name = nameTextField.text ?? ""
        let ingredients = ingredientsTextField.text ?? ""
        let date = datePicker.date
        let image = photoImageView.image ?? UIImage(named: "defaultPhoto")
        
        recipe = Recipe(name: name, ingredients: ingredients, date: date, image: image!)
    }
}
