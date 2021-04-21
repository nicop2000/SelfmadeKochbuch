//
//  Favs.swift
//  Kochbuch
//
//  Created by Nico Petersen on 01.03.21.
//

import SwiftUI

class Favs: ObservableObject {
    
    @Published var favorites = UserDefaults.standard.favsForKey(key: "favs")
    @State private var ids: [String] = []
    let defaults = UserDefaults.standard
    
    
    
    func add(rezept: Recipe) {
        favorites.append(rezept)
        ids.append("\(rezept.id!)")

    }
    
    func getIndex(findId: String) -> Int {
        var index = 0
        if (favorites.count - 1 > 0) {
            for i in 0...favorites.count - 1 {
                if "\(favorites[i].id!)" == findId {
                index  = i
                }
            }
            
            
        }
        return index
    }
    
    func remove(rezept: Recipe) {
        var index = 0
        if (favorites.count - 1 > 0) {
            for i in 0...favorites.count - 1 {
                if favorites[i].title == rezept.title! {
                index  = i
                }
            }
            favorites.remove(at: index)
            
        }
        
        
    }
    
    
    
    
    
    
}
