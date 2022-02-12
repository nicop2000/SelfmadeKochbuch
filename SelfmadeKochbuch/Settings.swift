//
//  Settings.swift
//  SelfmadeKochbuch
//
//  Created by Nico Petersen on 04.04.21.
//

import SwiftUI
import LocalAuthentication

struct Settings: View {
    var keyValStore = NSUbiquitousKeyValueStore.default
    @EnvironmentObject var favs: Favs
    @EnvironmentObject var categories: Categories
    @State private var titleCategory: String = ""
    
    let defaults = UserDefaults.standard
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.title, ascending: true)])
    private var rezepte: FetchedResults<Recipe>
    @State private var lockApp: Bool = UserDefaults.standard.bool(forKey: "locked")
    @State private var bgColor: Color = Color(UserDefaults.standard.colorForKey(key: "color") ?? .blue)
    @State private var test = "red"
    @State private var showAlert = false
    @State private var toBeDel: IndexSet?
    @State private var alertMsg = ""
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Du hast schon \(rezepte.count) Rezepte gesammelt")
                Group {
                    ColorPicker("Farbthema der App auswählen", selection: $bgColor)
                        .padding(.horizontal)
                        .padding(.bottom, 0)
                    HStack {
                        Text("Beispieltext")
                            .padding(.all, 5)
                            .padding(.top, 0)
                            .background(Color.white)
                        Text("Beispieltext")
                            .padding(.all, 5)
                            .background(Color.black)
                    }.foregroundColor(bgColor)
                }
                Toggle("App schützen (Face ID, Touch ID, Code)", isOn: $lockApp)
                    .padding()
                Spacer()
                
                Button("Speichern (App-Neustart erforderlich)") {
                    saveSettings()
                }.foregroundColor(Color(defaults.colorForKey(key: "color") ?? .blue))
                    .padding()
                Spacer()
                Group {
                    Text("Neue Kategorie hinzufügen")
                        .fontWeight(Font.Weight.bold)
                        .underline()
                    TextField("Name der neuen Kategorie", text: $titleCategory)
                        .padding()
                    Button("Kategorie hinzufügen") {
                        categories.add(kategorie: titleCategory)
                        titleCategory = ""
                    }.foregroundColor(Color(defaults.colorForKey(key: "color") ?? .blue))
                        .padding()
                        .opacity(titleCategory != "" ? 1.0 : 0.0)
                    
                }
                
                Spacer()
                Group {
                    Text("Eigene Kategorien verwalten")
                        .fontWeight(Font.Weight.bold)
                        .underline()
                    
                    VStack {
                        List{
                            ForEach(Array(getArrayPick()), id: \.self) { abteilung in
                                Text(abteilung)
                            }.onDelete(perform: deleteCategory)
                        }.listRowBackground(colorScheme == .dark ? Color.black : Color(UIColor(red: 241/255, green: 241/255, blue: 246/255, alpha: 1.0)))
                            .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("Wirklich löschen?"),
                                    message: Text("Kann nicht rückgängig gemacht werden"),
                                    primaryButton: .destructive(Text("Löschen")) {
                                        categories.remove(at: toBeDel!)
                                    },
                                    secondaryButton: .cancel(Text("Abbrechen"))
                                )
                                
                            }
                            
                        }
                }
                
                
                
            }
                
                
                
                
            }.navigationBarTitle("Einstellungen")
            
    }

private func deleteCategory(offsets: IndexSet) {
    showAlert = true
    toBeDel = offsets
    
    
}


    
    func getArrayPick() -> [String] {
        var abteilungPick: [String] = []
        for category in categories.categories {
            abteilungPick += [category]
        }
        return abteilungPick
    }
    
   
    
    func saveSettings() {
        defaults.setColor(color: UIColor(bgColor), forKey: "color")
        
        
        
        if (lockApp && (UserDefaults.standard.bool(forKey: "locked") == false)) {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                let reason = "Bitte identifizieren"
                
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                    
                    DispatchQueue.main.async {
                        if success {
                            UserDefaults.standard.set(true, forKey: "locked")
                        } else {
                            UserDefaults.standard.set(false, forKey: "locked")
                        }
                    }
                }
            } else {
                UserDefaults.standard.set(false, forKey: "locked")
                context.invalidate()
            }
            
            
            
            
        } else if (!lockApp && (UserDefaults.standard.bool(forKey: "locked") == true)){
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                let reason = "Bitte identifizieren"
                
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                    
                    DispatchQueue.main.async {
                        if success {
                            UserDefaults.standard.set(false, forKey: "locked")
                        } else {
                            UserDefaults.standard.set(true, forKey: "locked")
                        }
                    }
                }
            } else {
                UserDefaults.standard.set(true, forKey: "locked")
                context.invalidate()
            }
            
        }
    }
}

extension UserDefaults {
    func colorForKey(key: String) -> UIColor? {
        var colorReturnded: UIColor?
        if let colorData = data(forKey: key) {
            do {
                if let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor {
                    colorReturnded = color
                }
            } catch {
                print("Error UserDefaults")
            }
        }
        return colorReturnded
    }
    
    func favsToData(favs: [Recipe]?, forKey key: String) {
        var favsData: NSData?
        if let favs = favs {
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: favs, requiringSecureCoding: false) as NSData?
                favsData = data
            } catch {
                print("Error UserDefaults Favs")
            }
        }
    }
    
    func favsForKey(key: String) -> [Recipe] {
        var favsReturned: [Recipe]?
        if let favsData = data(forKey: key) {
            do {
                if let favs = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(favsData) as? [Recipe] {
                    favsReturned = favs
                }
            } catch {
                print("Error UserDefaults Favs get")
            }
        }
        return favsReturned ?? [Recipe]()
    }
    
    func categoriesForKey(key: String) -> [String] {
        var categoriesReturned: [String]?
        if let categoriesData = data(forKey: key) {
            do {
                if let categories = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(categoriesData) as? [String] {
                    categoriesReturned = categories
                }
            } catch {
                print("Error UserDefaults Categories get")
            }
        }
        return categoriesReturned ?? []
    }
    
    func setCategories(category: [String]?, forKey key: String) {
        var categoryData: NSData?
        if let category = category {
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: category, requiringSecureCoding: false) as NSData?
                categoryData = data
            } catch {
                print("Error UserDefaults")
            }
        }
        set(categoryData, forKey: key)
    }
    
    func setColor(color: UIColor?, forKey key: String) {
        var colorData: NSData?
        if let color = color {
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) as NSData?
                colorData = data
            } catch {
                print("Error UserDefaults")
            }
        }
        set(colorData, forKey: key)
    }
}
extension NSUbiquitousKeyValueStore {
    func colorForKey(key: String) -> UIColor? {
        var colorReturnded: UIColor?
        if let colorData = data(forKey: key) {
            do {
                if let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor {
                    colorReturnded = color
                }
            } catch {
                print("Error UserDefaults")
            }
        }
        return colorReturnded
    }
    
    func setColor(color: UIColor?, forKey key: String) {
        var colorData: NSData?
        if let color = color {
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) as NSData?
                colorData = data
            } catch {
                print("Error UserDefaults")
            }
        }
        set(colorData, forKey: key)
    }
}


struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
