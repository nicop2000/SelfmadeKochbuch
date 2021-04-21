//
//  SelfmadeKochbuchApp.swift
//  SelfmadeKochbuch
//
//  Created by Nico Petersen on 01.03.21.
//

import SwiftUI

@main
struct SelfmadeKochbuchApp: App {
    let persistenceContainer = PersistenceController.shared
    
    
    @StateObject var favs = Favs()
    
    

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceContainer.container.viewContext)
                .environmentObject(favs)
                
            
               
        }
        
    }

}

