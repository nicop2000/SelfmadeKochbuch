//
//  FavoritesView.swift
//  SelfmadeKochbuch
//
//  Created by Nico Petersen on 04.03.21.
//

import SwiftUI
import AudioToolbox

let defaults = UserDefaults.standard
struct FavoritesView: View {
    @EnvironmentObject var favs: Favs
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        if (favs.favorites.count == 0) {
            NavigationView {
                Text("Bislang noch nichts zur Merkliste hinzugefügt")
                    .navigationTitle("Merkliste")
                    .listStyle(InsetGroupedListStyle())
            }
        } else {
        NavigationView {
            List {
                Section {
                    ForEach(favs.favorites) { favorit in
                        NavigationLink(
                            destination: DetailView(rezept: favorit)) {
                            HStack {
                                Text(favorit.title ?? "Unbekannt")
                                    
                                Spacer()
                                Image(uiImage: UIImage(data: (favorit.picture ?? UIImage(named: "placeholder")!.jpegData(compressionQuality: 1.0))!)!)
                                    .resizable()
                                    .frame(width: 40, height: 40, alignment: .center)
                                    .clipShape(Circle())
                                    .opacity(favorit.picture == nil ? 0.0 : 1.0)
                                
                                
                                
                                
                                
                            }.padding(.horizontal)
                        }
                        
                    }.onDelete(perform: deleteRecipe)
                }
            }.navigationTitle("Merkliste")
            .listStyle(InsetGroupedListStyle())
            .toolbar {
                EditButton()
            }
        }
    }
    }
    private func deleteRecipe(at offsets: IndexSet) {
        withAnimation {
            
          offsets.map {favs.favorites[$0].fav = false}
            
            
            favs.favorites.remove(atOffsets: offsets)
            AudioServicesPlayAlertSound(SystemSoundID(1050))

            
           
            
        }
        
    }
}


struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            
            .environmentObject(Favs())
    }
}
