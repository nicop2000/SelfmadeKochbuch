//
//  EditView.swift
//  SelfmadeKochbuch
//
//  Created by Nico Petersen on 07.03.21.
//

import SwiftUI
import CoreData

struct EditView: View {
    let rezeptEdit: Recipe
    let defaults = UserDefaults.standard
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var favs: Favs
    @State var shown: Bool = true
    @Environment(\.colorScheme) var colorScheme
    @State private var status: String = "Auf Merkliste setzen"
    @State private var sharedSheet: Bool = false
    @State private var items: [Any] = []
    @State private var urlFile: URL?
    
    
    @State var title: String
    @State var summary: String
    @State var abteilung: String
    @State var link: String
    @State var ingredients: String
    @State var instructions: String
    @State var backzeit: String
    @State var temp: String
    @State var picture: Data?
    
    @State private var showPicSheet: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var image: UIImage?
    
    
    
    let abteilungPick = ["Frühstück", "Mittagessen", "Abendessen", "Torte/Kuchen", "Kekse/Gebäck", "Dessert", "Salate", "Anderes"]
    let abteilungSave: [String: String] = ["Frühstück": "fruehstueck", "Mittagessen": "mittag", "Abendessen": "abend", "Torte/Kuchen": "torte", "Kekse/Gebäck": "keks", "Dessert": "dessert", "Salate": "salate", "Anderes": "other"]
    var body: some View {
        
        
        
        
        
        NavigationView {
            Form {
                Section {
                    HStack {
                        
                        Button("Bild löschen") {
                            image = nil
                        }
                        .opacity((image != nil ? 1.0 : 0.0))
                        Spacer()
                        Button("Bild hinzufügen") {
                            showPicSheet = true
                            
                        }.actionSheet(isPresented: $showPicSheet){
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
                    .padding(.trailing, 2)
                    
                }
                
                
                
                Section {
                    HStack {
                        Spacer()
                        Image(uiImage: (image ?? UIImage(named: "placeholderDetail-3"))!)
                            .resizable()
                            .frame(width: 300, height: 300, alignment: .top)
                            .opacity((image != nil ? 1.0 : 0.0))
                            .scaledToFit()
                            .clipShape(Circle())
                        Spacer()
                    }
                }
                
                
                Section {
                    HStack {
                        VStack {
                            VStack(alignment: .leading){
                                Text("Titel:")
                                    .underline()
                                    .padding(.vertical, 2)
                                    .font(.title3)
                                    .foregroundColor(Color(defaults.colorForKey(key: "color") ?? .blue))
                                
                                TextEditor(text: $title)
                                
                                
                            }.padding(.bottom, 10)
                            .padding(.horizontal, 10)
                            
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        }
                    }
                    Section {
                        HStack {
                            
                            VStack(alignment: .leading) {
                                
                                Picker("Art des Rezeptes", selection: $abteilung) {
                                    ForEach(abteilungPick, id: \.self) {
                                        Text($0)
                                    }
                                }
                            }.padding(.bottom, 10)
                            .padding(.horizontal, 10)
                            
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        }
                    }.onAppear {
                        if(instructions == "") {
                            instructions = "\n"
                        }
                        if(summary == "") {
                            summary = "\n"
                        }
                        if(link == "") {
                            link = "\n"
                        }
                        if(ingredients == "") {
                            ingredients = "\n"
                        }
                        if (rezeptEdit.picture != nil) {
                        image = UIImage(data: rezeptEdit.picture!)
                        }
                        
                        
                       
                    }
                    
                    
                    VStack(alignment: .leading) {
                        Text("Anleitung:")
                            .underline()
                            .padding(.vertical, 2)
                            .font(.title3)
                            .foregroundColor(Color(defaults.colorForKey(key: "color") ?? .blue))
                        
                        TextEditor(text: $instructions)
                        
                    }.padding(.bottom, 10)
                    .padding(.horizontal, 10)
                    
                    
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    VStack(alignment: .leading) {
                        Text("Zutaten:")
                            .underline()
                            .padding(.vertical, 2)
                            .font(.title3)
                            .foregroundColor(Color(defaults.colorForKey(key: "color") ?? .blue))
                        TextEditor(text: $ingredients)
                        
                    }.padding(.bottom, 10)
                    .padding(.horizontal, 10)
                    
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    
                    if (abteilungSave[abteilung] == "keks" || abteilungSave[abteilung] == "torte") {
                    VStack(alignment: .leading) {
                        
                            Text("Backzeit in Minuten:")
                            .underline()
                            .padding(.vertical, 2)
                            .font(.title3)
                            .foregroundColor(Color(defaults.colorForKey(key: "color") ?? .blue))
                        TextEditor(text: $backzeit)
                            Spacer()
                            Text("Temperatur in °C:")
                            .underline()
                            .padding(.vertical, 2)
                            .font(.title3)
                            .foregroundColor(Color(defaults.colorForKey(key: "color") ?? .blue))
                        TextEditor(text: $temp)
                            
                        
                        
                    }.padding(.bottom, 10)
                    .padding(.horizontal, 10)
                    
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Link:")
                            .underline()
                            .padding(.vertical, 2)
                            .font(.title3)
                            .foregroundColor(Color(defaults.colorForKey(key: "color") ?? .blue))
                        TextEditor(text: $link)
                        
                    }.padding(.bottom, 10)
                    .padding(.horizontal, 10)
                    
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                }
                
                
                HStack {
                    Button("Speichern") {
                        rezeptEdit.title = (title != "" ? title : rezeptEdit.title)
                        rezeptEdit.ingredients = ingredients
                        rezeptEdit.instructions = instructions
                        rezeptEdit.link = link
                        rezeptEdit.summary = summary
                        
                        rezeptEdit.abteilung = abteilungSave[abteilung] ?? rezeptEdit.abteilung
                        rezeptEdit.picture = image?.jpegData(compressionQuality: 1.0)
                        do {
                            try self.moc.save()
                            self.presentationMode.wrappedValue.dismiss()
                        } catch {
                            print(error)
                        }
                        
                    }
                    Image(systemName: "externaldrive.badge.checkmark")
                    
                }.padding(.horizontal, 10)
            }
            
            
            
        }.navigationBarItems(leading: backButton)
        .navigationBarTitle("\(rezeptEdit.title!) bearbeiten", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        
        .sheet(isPresented: $showImagePicker){
            ImagePicker(image: self.$image, isShown: self.$showImagePicker, sourceType: self.sourceType)
        }
        
        
        
        
    }
    
    
    var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
            
        }) {
            HStack{
                Image(systemName: "chevron.left")
                Text("\(rezeptEdit.title!)")
                    .offset(x: -5.0)
                
            }
            .foregroundColor(Color(defaults.colorForKey(key: "color") ?? .blue))
            .font(.title3)
        }
    }
    
    
    
}





struct EditView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
        let rezept = Recipe(context: moc)
        rezept.title = "TITEL"
        rezept.abteilung = "ABT"
        rezept.id = UUID()
        rezept.ingredients = "INGRED"
        rezept.summary = "SUMM"
        rezept.link = "http://google.de"
        rezept.picture = UIImage(named: "placeholderDetail-3")!.jpegData(compressionQuality: 1.0)!
        rezept.instructions = "INST"
        rezept.backzeit = 60
        rezept.temperatur = 180
        
        
        return NavigationView{
            EditView(rezeptEdit: rezept, title: rezept.title!, summary: rezept.summary!, abteilung: rezept.abteilung!, link: rezept.link!, ingredients: rezept.ingredients!, instructions: rezept.instructions!, backzeit: "\(rezept.backzeit)", temp: "\(rezept.temperatur)")
                .environmentObject(Favs())
        }
    }
}
