//
//  Importieren.swift
//  SelfmadeKochbuch
//
//  Created by Nico Petersen on 06.03.21.
//

import SwiftUI
import AudioToolbox

struct Importieren: View {
    @State var fileName = ""
    let defaults = UserDefaults.standard
    @State var openFile = false
    @State var successSheet = false
    @State var msg = ""
    @Environment(\.managedObjectContext) var moc
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationView {
        VStack {
            
            Spacer()
            Text("Hier kann ein Rezept, das dir ein anderer Benutzer geschickt hat, in die eigene Sammlung hinzugefügt werden")
                .padding(.horizontal, 10)
                .font(.title3)
            
            Button("Hier Datei auswählen") {
                openFile.toggle()
            }.foregroundColor(Color(defaults.colorForKey(key: "color") ?? .green))
            .padding()
            Spacer()
        }.padding(.horizontal, 20)
        .navigationBarTitle("Rezeptimport")
        .fileImporter(isPresented: $openFile, allowedContentTypes: [.json]) { res in
            
            do {
                let fileURL = try res.get()
                _ = fileURL.startAccessingSecurityScopedResource()
                print(fileURL)
                self.fileName = fileURL.lastPathComponent
                let jsonDataImport = try Data.init(contentsOf: fileURL)
                print(fileURL)
                fileURL.stopAccessingSecurityScopedResource()
                
                let decodedRecipe = try JSONDecoder().decode(RecipeImport.self, from: jsonDataImport)
                print(decodedRecipe)
                print(decodedRecipe.title)
                
                let rezept = Recipe(context: moc)
                rezept.title = decodedRecipe.title
                rezept.abteilung = decodedRecipe.abteilung
                rezept.id = UUID()
                rezept.ingredients = decodedRecipe.ingredients ?? ""
                rezept.summary = decodedRecipe.summary ?? ""
                rezept.link = decodedRecipe.link ?? ""
                rezept.picture = UIImage(named: "placeholderDetail-3")!.jpegData(compressionQuality: 1.0)!
                rezept.instructions = decodedRecipe.instructions ?? ""
                msg = "Importieren erfolgreich abgeschlossen"
                
                do {
                try self.moc.save()
                    AudioServicesPlayAlertSound(SystemSoundID(1102))
                    successSheet.toggle()
                    
                } catch {
                    AudioServicesPlayAlertSound(SystemSoundID(1053))
                    successSheet.toggle()
                    msg = "Fehler beim Speichern des Rezepts"
                    print(error)
                }
            } catch {
                AudioServicesPlayAlertSound(SystemSoundID(1053))
                successSheet.toggle()
                msg = "Importieren der Datei nicht möglich"
                print("Error \(error) + Beschreibung: \(error.localizedDescription) --> ENDE")
                
            }
        }.sheet(isPresented: $successSheet, content: {
            
            Text(msg)
                .foregroundColor((colorScheme == .dark ? Color.white : Color.black))
        })
        }
    }
}

struct Importieren_Previews: PreviewProvider {
    static var previews: some View {
        Importieren()
    }
}
