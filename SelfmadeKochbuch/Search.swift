//
//  Search.swift
//  SelfmadeKochbuch
//
//  Created by Nico Petersen on 04.04.21.
//

import SwiftUI
import AudioToolbox



struct Search: View {
    @State private var showAlert = false
    let defaults = UserDefaults.standard
    @State private var alertMsg = ""
    @Environment(\.managedObjectContext) var moc
    @State private var toBeDel: IndexSet?
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    @Environment(\.colorScheme) var colorScheme
   
    
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.title, ascending: true)])
    private var rezepte: FetchedResults<Recipe>
    var body: some View {
        VStack {
          NavigationView  {
            List {
                ForEach(rezepte, id: \.id) { rezept in
                    if(rezept.title!.hasPrefix(searchText) || searchText == "") {
                    
                    NavigationLink(destination: DetailView(rezept: rezept)) {
                   ItemRow(rezept: rezept)
                }
                    }

                    
                }.onDelete(perform: deleteRecipe)
            }.navigationBarTitle(Text("Suchen"))
            .resignKeyboardOnDragGesture()
            
            .listRowBackground(colorScheme == .dark ? Color.black : Color(UIColor(red: 241/255, green: 241/255, blue: 246/255, alpha: 1.0)))
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
            
          }
        
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")

                TextField("Suchen", text: $searchText, onEditingChanged: { isEditing in
                    self.showCancelButton = true
                }, onCommit: {
                    print("onCommit")
                }).foregroundColor(.primary)

                Button(action: {
                    self.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)

            if showCancelButton  {
                Button("Cancel") {
                        UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                        self.searchText = ""
                        self.showCancelButton = false
                }
                .foregroundColor((Color(defaults.colorForKey(key: "color") ?? .green)))
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
        
        .navigationBarHidden(showCancelButton)
        .animation(.default) // animation does not work properly
        }
        
      
                            // Filtered list of names
//            ForEach(rezepte.title.filter{$0.hasPrefix(searchText) || searchText == ""}, id:\.rezepte.id) {
//                                searchText in Text(searchText)
//                            }
                        
                        
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

struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search()
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}
