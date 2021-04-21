//
//  ContentView.swift
//  Kochbuch
//
//  Created by Nico Petersen on 01.03.21.
//

import SwiftUI
import AudioToolbox


struct ContentView: View {
    @State private var showAlert = false
    let defaults = UserDefaults.standard
    @State private var alertMsg = ""
    @Environment(\.managedObjectContext) var moc
    @State private var toBeDel: IndexSet?
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.title, ascending: true)])
    private var rezepte: FetchedResults<Recipe>
    
    
    
    
    @State private var showingAddScreen = false
    @EnvironmentObject var favs: Favs
    @Environment(\.colorScheme) var colorScheme
   
    //.background(colorScheme == .dark ? Color.red : Color.yellow)
    
    
    
    
    
    
    
    
    
    var body: some View {
        
        NavigationView {
            VStack {
                List{
                    Section(header: Text("Frühstück")) {
                        ForEach(rezepte, id: \.id) { rezept in
                            if(rezept.abteilung! == "fruehstueck") {
                                  NavigationLink(destination: DetailView(rezept: rezept)) {
                                 ItemRow(rezept: rezept)
                                    
                                    
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
                    Section(header: Text("Mittagessen")) {
                        ForEach(rezepte, id: \.id) { rezept in
                            if(rezept.abteilung! == "mittag") {
                                NavigationLink(destination: DetailView(rezept: rezept)) {
                               ItemRow(rezept: rezept)
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
                    Section(header: Text("Abendessen")) {
                        ForEach(rezepte, id: \.id) { rezept in
                            if(rezept.abteilung! == "abend") {
                                NavigationLink(destination: DetailView(rezept: rezept)) {
                               ItemRow(rezept: rezept)
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
                    Section(header: Text("Torte/Kuchen")) {
                        ForEach(rezepte, id: \.id) { rezept in
                            if(rezept.abteilung! == "torte") {
                                NavigationLink(destination: DetailView(rezept: rezept)) {
                               ItemRow(rezept: rezept)
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
                    Section(header: Text("Kekse/Gebäck")) {
                        ForEach(rezepte, id: \.id) { rezept in
                            if(rezept.abteilung! == "keks") {
                                NavigationLink(destination: DetailView(rezept: rezept)) {
                                    ItemRow(rezept: rezept)
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
                    Section(header: Text("Dessert")) {
                        ForEach(rezepte, id: \.id) { rezept in
                            if(rezept.abteilung! == "dessert") {
                                NavigationLink(destination: DetailView(rezept: rezept)) {
                                    ItemRow(rezept: rezept)
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
                    Section(header: Text("Salate")) {
                        ForEach(rezepte, id: \.id) { rezept in
                            if(rezept.abteilung! == "salate") {
                                NavigationLink(destination: DetailView(rezept: rezept)) {
                                    ItemRow(rezept: rezept)
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
                    Section(header: Text("Anderes")) {
                        ForEach(rezepte, id: \.id) { rezept in
                            if(rezept.abteilung! == "other") {
                                NavigationLink(destination: DetailView(rezept: rezept)) {
                                    ItemRow(rezept: rezept)
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
                }.background(Color.red)
                
                
                
                
                .navigationTitle("Rezepte Sammlung")
                .listStyle(GroupedListStyle())
            }
            
            .navigationBarItems(leading: Button(action: {
                self.showingAddScreen.toggle()
            }) {
                HStack {
                    Text("Rezept hinzufügen")
                Image(systemName: "plus")
                }
            }.foregroundColor(Color(defaults.colorForKey(key: "color") ?? .green))
            )
            .toolbar {
                EditButton()
                    
            }
            .sheet(isPresented: $showingAddScreen) {
                AddItem().environment(\.managedObjectContext, self.moc)
            }
        }.foregroundColor(Color(defaults.colorForKey(key: "color") ?? .green))
        
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



