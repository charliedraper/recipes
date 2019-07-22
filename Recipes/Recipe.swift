//
//  Recipe.swift
//  Recipes
//
//  Created by Charlie Draper on 7/17/19.
//  Copyright © 2019 Charlie Draper. All rights reserved.
//

import UIKit

class Recipe : NSObject, NSCoding, Comparable {
    
    //MARK: - Properties
    
    let name: String
    let ingredients: String
    let date: Date
    let image: UIImage
    
    //MARK: - Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("recipes")
    
    //MARK: - Types
    
    struct PropertyKey {
        static let name = "name"
        static let ingredients = "ingredients"
        static let date = "date"
        static let image = "image"
    }
    
    //MARK: - Initialization
    
    init(name: String, ingredients: String, date: Date, image: UIImage) {
        self.name = name
        self.ingredients = ingredients
        self.date = date
        self.image = image
    }
    
    //MARK: - Static Methods
    
    static func < (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.date < rhs.date
    }
    
    //MARK: - NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(ingredients, forKey: PropertyKey.ingredients)
        aCoder.encode(date, forKey: PropertyKey.date)
        aCoder.encode(image, forKey: PropertyKey.image)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else { return nil }
        let ingredients = aDecoder.decodeObject(forKey: PropertyKey.ingredients) as? String ?? ""
        let date = aDecoder.decodeObject(forKey: PropertyKey.date) as? Date ?? Date(timeIntervalSinceNow: 0)
        let image = aDecoder.decodeObject(forKey: PropertyKey.image) as? UIImage ?? UIImage(named: "defaultPhoto")!
        
        self.init(name: name, ingredients: ingredients, date: date, image: image)
    }
}

//Global recipe variable
var recipes = [Recipe]()
