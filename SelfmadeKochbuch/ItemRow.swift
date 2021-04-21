//
//  ItemRow.swift
//  Kochbuch
//
//  Created by Nico Petersen on 01.03.21.
//

import SwiftUI
import CoreData

struct ItemRow: View {
    let defaults = UserDefaults.standard
        
//    let item: MenuItem
    let colors: [String: Color] = ["fruehstueck": .green, "mittag": .orange, "abend": .blue, "torte": .pink, "keks": .purple, "dessert": .red]
    let names: [String: String] = ["fruehstueck": "F", "mittag": "M", "abend": "A", "torte": "T", "keks": "K", "dessert": "D"]
    @State private var name = "heart"
    let rezept: Recipe
    @Environment(\.colorScheme) var colorScheme
    
       
        
    
    var body: some View {
        
        HStack {
                  
            
            
            Text(rezept.title ?? "Fehler")
                .foregroundColor((colorScheme == .dark ? Color.white : Color.black))
                
            
            
           // Image(uiImage: picture as UIImage)
                
            Spacer()
            Image(uiImage: UIImage(data: (rezept.picture ?? UIImage(named: "placeholder")!.jpegData(compressionQuality: 1.0))!)!)
                .resizable()
                .frame(width: 40, height: 40, alignment: .center)
                .clipShape(Circle())
                .opacity((rezept.picture == nil ? 0.0 : 1.0))
            
//            Text(names[rezept.abteilung!]!)
//                .padding(.all, 8)
//                .background(colors[rezept.abteilung!])
//                .clipShape(Circle())
//                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
            
            
            
            
            
        }
        
        
        
        
    }
}

struct ItemRow_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
        let rezept = Recipe(context: moc)
        rezept.title = "Testrezept"
        rezept.abteilung = "mittag"
        rezept.id = UUID()
        rezept.ingredients = "Zucker und Mehl"
        rezept.summary = "Sehr lecker"
        rezept.link = "http://google.de"
        rezept.picture = UIImage(named: "placeholderDetail-3")!.jpegData(compressionQuality: 1.0)!
        
        
        return NavigationView{
            ItemRow(rezept: rezept)
        }
    }
}
