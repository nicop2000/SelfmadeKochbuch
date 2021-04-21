//
//  MainView.swift
//  SelfmadeKochbuch
//
//  Created by Nico Petersen on 04.03.21.
//

import SwiftUI
import LocalAuthentication

struct MainView: View {
    @State var opacity = 1.0
    
    let defaults = UserDefaults.standard
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.title, ascending: true)])
    private var rezepte: FetchedResults<Recipe>
    var body: some View {
        
        TabView(){
            ContentView()
                .tabItem {
                    Label("Rezeptesammlung", systemImage: "folder.fill")
                }
            
            FavoritesView()
                .tabItem {
                    Label("Merkliste", systemImage: "heart.fill")
                }
            
            SafariView(url: URL(string: "https://google.de")!)
                .tabItem {
                    Label("Safari", systemImage: "safari")
                }
            
            Settings()
                .tabItem {
                    Label("Einstellungen", systemImage: "gear")
                }
            
            Search()
                .tabItem {
                    Label("Suchen", systemImage: "doc.text.magnifyingglass")
                }
            
            Importieren()
                .tabItem {
                    Label("Import", systemImage: "square.and.arrow.down.fill")
                }
            
            
                
            
        }.accentColor(Color(defaults.colorForKey(key: "color") ?? .green))
        
        .opacity(opacity)
        .onAppear {
            
            
            if (UserDefaults.standard.bool(forKey: "locked")) {
                opacity = 0.0
            let context = LAContext()
            var error: NSError?
                
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                let reason = "Bitte identifizieren"
                
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in

                    DispatchQueue.main.async {
                        if success {
                            opacity = 1.0
                        } else {
                            exit(-1)
                        }
                    }
                }
            } else {
                UserDefaults.standard.set(false, forKey: "locked")
                context.invalidate()
                exit(-1)
            }
        }
    }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(Favs())
            
    }
}



