//
//  ContentView.swift
//  Kochbuch
//
//  Created by Nico Petersen on 01.03.21.
//

import SwiftUI
import AudioToolbox


struct ContentView: View {
    
    let defaults = UserDefaults.standard
    
    @Environment(\.managedObjectContext) var moc
    @State private var showAlert = false
    @State private var toBeDel: IndexSet?
    @State private var alertMsg = ""
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.title, ascending: true)])
    private var rezepte: FetchedResults<Recipe>
    
    
    
    
    @State private var showingAddScreen = false
    @EnvironmentObject var favs: Favs
    @EnvironmentObject var categories: Categories
    @Environment(\.colorScheme) var colorScheme
    
    //.background(colorScheme == .dark ? Color.red : Color.yellow)
    
    func getArrayPresentation() -> [String: String] {
        var abteilungSave = ["Frühstück": "fruehstueck", "Mittagessen": "mittag", "Abendessen": "abend", "Torte/Kuchen": "torte", "Kekse/Gebäck": "keks", "Dessert": "dessert", "Salate": "salate", "Anderes": "other"]
        let b = categories.categories
        var userCategoriesSave: [String: String] = [:]
        if (categories.categories.count > 0) {
            for index in 0...categories.categories.count - 1 {
                userCategoriesSave = userCategoriesSave.merging([categories.categories[index]:"u\(index)"]) { (current, _) in current }
                
            }
            
        }
        
        return userCategoriesSave.merging(abteilungSave) { (current, _) in current }
    }
    
    
    
    
    
    
    
    var body: some View {
        
        
        NavigationView {
            
            VStack {
                if(rezepte.isEmpty) {
                    Text("Keine Rezepte vorhanden")
                }
                List{
                    ForEach(getAndereAbteilungen(), id: \.self) {
                        abteilung in
                        Section(header: Text(getArrayPresentation().someKey(forValue: abteilung) ?? abteilung)) {
                    ForEach(rezepte, id: \.id) { rezept in
                        if (rezept.abteilung! == abteilung) {
                            
                                NavigationLink(destination: DetailView(rezept: rezept)) {
                                    ItemRow(rezept: rezept)
                                }
                                
                                
                                
                            }
                        }
                    }
                        
                    }.onDelete(perform: deleteRecipe)
                }.listRowBackground(colorScheme == .dark ? Color.black : Color(UIColor(red: 241/255, green: 241/255, blue: 246/255, alpha: 1.0)))
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Wirklich löschen?"),
                            message: Text("Kann nicht rückgängig gemacht werden"),
                            primaryButton: .destructive(Text("Löschen")) {
                                deleteAtLast(offsets: toBeDel!)
                            },
                            secondaryButton: .cancel(Text("Abbrechen"))
                        )
                        
                    }
                
            
            
            
            
        } .navigationTitle("Rezepte Sammlung")
            .listStyle(GroupedListStyle())
            .navigationBarItems(
                leading: Button(action: {
                    self.showingAddScreen.toggle()
                }) {
                    HStack {
                        Text("Rezept hinzufügen")
                        Image(systemName: "plus")
                    }
                }.foregroundColor(Color(defaults.colorForKey(key: "color") ?? .blue))
            )
            .toolbar {
                EditButton()
                
            }
            .sheet(isPresented: $showingAddScreen) {
                AddItem().environment(\.managedObjectContext, self.moc)
            }
            .foregroundColor(Color(defaults.colorForKey(key: "color") ?? .blue))
    }
    }
    
    
    
    func getAndereAbteilungen() -> [String] {
        var rest: Set<String> = [];
        rezepte.forEach {
            rest.insert($0.abteilung!)
        }
        return rest.sorted()
    }
    
    func swipeRightToLeft() {
        print("LEFT")
    }
    
    func swipeLeftToRight() {
        print("RIGHT")
    }
    
    private func deleteRecipe(offsets: IndexSet) {
        showAlert = true
        toBeDel = offsets
        
        
    }
    
    private func deleteAtLast(offsets: IndexSet) {
        withAnimation {
            offsets.map {rezepte[$0]}.forEach(moc.delete)
            AudioServicesPlayAlertSound(SystemSoundID(1109))
            
            do {
                try self.moc.save()
            } catch {
                alertMsg = "Fehler beim Löschen des Rezeptes"
                showAlert = true
                AudioServicesPlayAlertSound(SystemSoundID(1053))
                print(error)
            }
            
        }
    }
}


extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



