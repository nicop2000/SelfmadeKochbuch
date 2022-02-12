//
//  AddItem.swift
//  Selfmade Kochbuch
//
//  Created by Nico Petersen on 02.03.21.
//

import SwiftUI
import AudioToolbox

struct AddItem: View {
    let defaults = UserDefaults.standard
    @EnvironmentObject var categories: Categories
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    @State private var alertMsg = ""
    
    @State private var title: String = ""
    @State private var ingredientsAsString: String = ""
    @State private var instructions: String = ""
    
    @State private var description: String = ""
    @State private var abteilung: String = ""
    @State private var link: String = ""
    @State private var backzeit: String = ""
    @State private var temp: String = ""
    
    @State private var showPicSheet: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var image: UIImage?
    @Environment(\.colorScheme) var colorScheme
    

        
    func getArrayPick() -> [String] {
        var abteilungPick = ["Frühstück", "Mittagessen", "Abendessen", "Torte/Kuchen", "Kekse/Gebäck", "Dessert", "Salate", "Anderes"]
        for category in categories.categories {
            abteilungPick += [category]
        }
        return abteilungPick
    }
    
    func getArraySave() -> [String: String] {
        var abteilungSave = ["Frühstück": "fruehstueck", "Mittagessen": "mittag", "Abendessen": "abend", "Torte/Kuchen": "torte", "Kekse/Gebäck": "keks", "Dessert": "dessert", "Salate": "salate", "Anderes": "other"]
        let b = categories.categories
        var userCategoriesSave: [String: String] = [:]
        if (categories.categories.count > 0) {
            for index in 0...categories.categories.count - 1 {
                userCategoriesSave = userCategoriesSave.merging([categories.categories[index]:categories.categories[index].replacingOccurrences(of: "ä", with: "ae").replacingOccurrences(of: "ö", with: "oe").replacingOccurrences(of: "ü", with: "ue").replacingOccurrences(of: "ß", with: "ss")]) { (current, _) in current }
                           
            }
        
        }
        
        return userCategoriesSave.merging(abteilungSave) { (current, _) in current }
    }
    
    var body: some View {
        
        
        NavigationView {
            Form {
                Section {
                    TextField("Name des Rezeptes", text: $title)
                    TextField("Beschreibung", text: $description)
                    Picker("Art des Rezeptes", selection: $abteilung) {
                        ForEach(getArrayPick(), id: \.self) {
                            Text($0)
                        }
                    }
                    TextField("Link zum Rezept", text: $link)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    TextField("Zutaten (mit Kommata trennen)", text: $ingredientsAsString)
                        .autocapitalization(.none)
                    ZStack(alignment: .leading) {
                        if instructions.isEmpty {
                            Text("Anleitung (mit Zeilenumbruch trennen)")
                                .foregroundColor(.gray)
                                .opacity(0.5)
                        }
                        TextEditor(text: $instructions)
                    }
                    if(getArraySave()[abteilung] == "torte" || getArraySave()[abteilung] == "keks") {
                        HStack {
                            TextField("Backzeit in Minuten", text: $backzeit)
                            Spacer()
                            TextField("Temperatur in °C", text: $temp)
                        }
                    }
                }
                if (image != nil) {
                HStack {
                    Spacer()
                
                        Image(uiImage: image ?? UIImage(systemName: "photo")!)
                            .resizable()
                            .frame(width:300, height: 300)
                            .padding(5)
                            .opacity((image == nil ? 0.0 : 1.0))
                            Spacer()
                            
                }
                    HStack {
                        Spacer()
                        Button("Bild löschen") {
                        image = nil
                    }.foregroundColor(Color(defaults.colorForKey(key: "color") ?? .blue))
                        .padding(.trailing, 2)
                    }
                }
                Section {
                    Button("Bild hinzufügen") {
                        showPicSheet = true
                    }
                    .actionSheet(isPresented: $showPicSheet){
                        ActionSheet(title: Text("Bild auswählen"), message: Text("Woher soll das Bild kommen?"), buttons: [
                            .default(Text("Fotomediathek")) {
                                self.showImagePicker = true
                                self.sourceType = .photoLibrary
                            },
                            .default(Text("Foto aufnehmen")){
                                self.showImagePicker = true
                                self.sourceType = .camera
                            },
                            .cancel()
                        ])
                    }
                }.foregroundColor(Color(defaults.colorForKey(key: "color") ?? .blue))
                Section {
                    Button("Speichern") {
                        print("TAPPED")
                        if (title == "") {
                            alertMsg = "Bitte Titel ausfüllen"
                            showAlert = true
                        } else {
                            addRecipe()
                        }
                    }
                }.foregroundColor(Color(defaults.colorForKey(key: "color") ?? .blue))
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Fehler"), message: Text(alertMsg), dismissButton: .default(Text("Okay")))
                }
                
            }.navigationBarTitle(Text("Neues Rezept hinzufügen"), displayMode: .inline)
            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
            
        }.sheet(isPresented: $showImagePicker){
            ImagePicker(image: self.$image, isShown: self.$showImagePicker, sourceType: self.sourceType)
        }
        
    }
    func addRecipe(){
        abteilung = getArraySave()[abteilung] ?? "other"
        
        let newRecipe = Recipe(context: self.moc)
        newRecipe.title = title
        newRecipe.id = UUID()
        newRecipe.abteilung = abteilung
        newRecipe.summary = description
        newRecipe.ingredients = ingredientsAsString
        newRecipe.link = link
        newRecipe.picture = image?.jpegData(compressionQuality: 1.0)
        newRecipe.instructions = instructions
       
        
        if(abteilung == "torte" || abteilung == "keks" ) {
            
        
            newRecipe.backzeit = Int16(backzeit) ?? 0
            newRecipe.temperatur = Int16(temp) ?? 0
            
            
        }
        print(newRecipe)
        
        saveRecipe()
       
        }
    
    func saveRecipe() {
        
        do {
            print(moc)
        try self.moc.save()
            self.presentationMode.wrappedValue.dismiss()
            AudioServicesPlayAlertSound(SystemSoundID(1102))
        } catch {
            AudioServicesPlayAlertSound(SystemSoundID(1053))
            alertMsg = "Fehler beim Hinzufügen des Rezeptes"
            showAlert = true
            print(error)
        }
    }
    
        
    
    }
        
    


struct AddItem_Previews: PreviewProvider {
    static var previews: some View {
        AddItem()
    }
}
