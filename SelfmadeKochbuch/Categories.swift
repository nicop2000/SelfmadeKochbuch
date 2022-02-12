//
//  Favs.swift
//  Kochbuch
//
//  Created by Nico Petersen on 01.03.21.
//

import SwiftUI

class Categories: ObservableObject {
    
    @Published var categories = UserDefaults.standard.categoriesForKey(key: "categories")
    let defaults = UserDefaults.standard
    
    
    
    func add(kategorie: String) {
        categories.append(kategorie)
        defaults.setCategories(category: categories, forKey: "categories")
    }
    

    func remove(at offsets: IndexSet) {
        categories.remove(atOffsets: offsets)
        defaults.setCategories(category: categories, forKey: "categories")
    }
    
    
    
    
    
    
}
