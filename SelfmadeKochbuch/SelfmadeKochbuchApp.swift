//
//  SelfmadeKochbuchApp.swift
//  SelfmadeKochbuch
//
//  Created by Nico Petersen on 03.03.21.
//

import SwiftUI

@main
struct SelfmadeKochbuchApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
