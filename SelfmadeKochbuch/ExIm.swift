//
//  ExIm.swift
//  Kochbuch
//
//  Created by Nico Petersen on 01.03.21.
//

import SwiftUI

//struct MenuSection: Codable, Identifiable {
//    var id: UUID
//    var name: String
//    var items : [MenuItem]
//}

struct RecipeExport: Codable {
    var id: UUID
    var title: String
    var ingredients: String?
    var summary: String?
    var instructions: String?
    var abteilung: String
    var link: String?
}

struct RecipeImport: Codable {
    var id: UUID
    var title: String
    var ingredients: String?
    var summary: String?
    var instructions: String?
    var abteilung: String
    var link: String?
}
