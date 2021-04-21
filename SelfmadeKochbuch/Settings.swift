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
    
    let defaults = UserDefaults.standard
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.title, ascending: true)])
    private var rezepte: FetchedResults<Recipe>
    @State private var lockApp: Bool = UserDefaults.standard.bool(forKey: "locked")
    @State private var bgColor: Color = Color(UserDefaults.standard.colorForKey(key: "color") ?? .green)
    @State private var test = "red"
    
    var body: some View {
        NavigationView {
            VStack {
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
                
                Toggle("App schützen (Face ID, Touch ID, Code)", isOn: $lockApp)
                    .padding()
                Spacer()
                Text("Du hast schon \(rezepte.count) Rezepte gesammelt")
                Button("Speichern (App-Neustart erforderlich)") {
                    saveSettings()
                }.foregroundColor(Color(defaults.colorForKey(key: "color") ?? .green))
                .padding()
            }.navigationBarTitle("Einstellungen")
            
        }
        
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
