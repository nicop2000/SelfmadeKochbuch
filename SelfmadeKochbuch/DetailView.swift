//
//  DetailView.swift
//  SelfmadeKochbuch
//
//  Created by Nico Petersen on 03.03.21.
//

import SwiftUI
import CoreData
import AudioToolbox

struct DetailView: View {
    let rezept: Recipe
    let defaults = UserDefaults.standard
    @State var name: String = "heart"
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var favs: Favs
    @State var shown: Bool = true
    @Environment(\.colorScheme) var colorScheme
    @State private var status: String = "Auf Merkliste setzen"
    @State private var sharedSheet: Bool = false
    @State private var items: [Any] = []
    @State private var urlFile: URL?
    

    
    let abteilungShow: [String: String] = ["fruehstueck": "Frühstück", "mittag": "Mittagessen", "abend": "Abendessen", "torte": "Torte/Kuchen", "keks": "Kekse/Gebäck", "dessert": "Dessert", "salate": "Salate", "other": "Anderes"]
    var body: some View {
        
        List {
            VStack {
                ZStack {
                    Image(uiImage: UIImage(data: (rezept.picture ?? UIImage(named: "placeholderDetail-3")!.jpegData(compressionQuality: 1.0))!)!)
                        .resizable()
                        .frame(width: 300, height: 300, alignment: .top)
                        
//                        .mask(Rectangle().padding(.vertical, 100))
//                        .clipShape(Rectangle())
                        .scaledToFit()
                        .clipShape(Circle())
                        .opacity((rezept.picture == nil ? 0.0 : 1.0))
                        
                    
                    Text(rezept.title ?? "Unbekannt")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(8)
                        .foregroundColor(.white)
                        
                        
                        .background((rezept.picture == nil ? Color.gray.opacity(1.0) : Color.gray.opacity(0.55)))
                        .clipShape(Capsule())
                        .offset(x: -5, y: -5)
                }
                Spacer()
                
                VStack(alignment: .leading, spacing: nil){
                    HStack {
                Text(self.rezept.summary ?? "Keine Beschreibung vorhanden")
                        Spacer()
                    }.padding(.bottom, 10)
                    .padding(.horizontal, 10)
                    .font(.title3)
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    let strArr = rezept.ingredients?.components(separatedBy: ",")
//                    let instArr = rezept.instructions?.components(separatedBy: "\n")
                    
                    
                   
                    VStack(alignment: .leading) {
                    Text("Zutaten:")
                        .underline()
                        .padding(.vertical, 2)
                        .font(.title2)
                        .foregroundColor(Color(defaults.colorForKey(key: "color") ?? .green))
                        ScrollView {
                        
                    ForEach(strArr!, id: \.self) { value in
                        HStack {
                        Text(value)
                            Spacer() }
                            
                                 
                    }
                        }
                    }.padding(.bottom, 10)
                    .padding(.horizontal, 8)
                    .font(.title3)
                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    
                    
                    VStack(alignment: .leading) {
                        Text("Anleitung:")
                            .underline()
                            .padding(.vertical, 2)
                            .font(.title2)
                            .foregroundColor(Color(defaults.colorForKey(key: "color") ?? .green))
                        ScrollView {Text(self.rezept.instructions ?? "Keine Anleitung vorhanden")
                        }
                          
                        }.padding(.bottom, 10)
                        .padding(.horizontal, 8)
                        .font(.title3)
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    
                    if (rezept.abteilung! == "keks" || rezept.abteilung! == "torte") {
                        HStack {
                        Text("Bei \(rezept.temperatur) °C \(rezept.backzeit) Minuten backen")
                        }.foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    }
                    
                    
                    
                    
                }
                Spacer()
            }
            if(rezept.link != "" && rezept.link != "\n" && rezept.link != nil) {
            Link("Rezept im Browser anzeigen", destination: URL(string: self.rezept.link!)!)
                .padding(.horizontal, 10)
                .foregroundColor(Color(defaults.colorForKey(key: "color") ?? .green))
                .font(.callout)
            }
            Button("Exportieren/Teilen") {
                exportRecipe()
                
            }
            .padding(.horizontal, 10)
            .foregroundColor(Color(defaults.colorForKey(key: "color") ?? .green))
            .font(.callout)
            editEntry
                .padding(.horizontal, 10)
                
                
            
            
            
        }/*.sheet(isPresented: $sharedSheet) {
           
            
        }*/
        
        .navigationBarItems(leading: backButton, trailing:favButton)
        .navigationBarBackButtonHidden(true)
        
        
        }
    
    var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
            
        }) {
            HStack{
                Image(systemName: "chevron.left")
                Text("Rezepte")
                    .offset(x: -5.0)
                    
            }
            .foregroundColor(Color(defaults.colorForKey(key: "color") ?? .green))
            .font(.title3)
        }
    }
    var editEntry: some View {
        
        NavigationLink(destination: EditView(rezeptEdit: rezept, title: rezept.title!, summary: rezept.summary!, abteilung: rezept.abteilung!, link: rezept.link!, ingredients: rezept.ingredients!, instructions: rezept.instructions!, backzeit: "\(rezept.backzeit)", temp: "\(rezept.temperatur)")) {
                HStack{
                    Text("Eintrag bearbeiten")
                    Image(systemName: "pencil")
                    
                   
                        
                }
                .font(.callout)
                .foregroundColor(Color(defaults.colorForKey(key: "color") ?? .green))
            }
            
        
    }
    
    var favButton: some View {
        Button(action: {
            if !rezept.fav {
                rezept.fav = true
                favs.add(rezept: rezept)
                AudioServicesPlayAlertSound(SystemSoundID(1102))
            } else {
                rezept.fav = false
                favs.remove(rezept: rezept)
                let remInd = favs.getIndex(findId: "\(rezept.id!)")
                if(favs.favorites.count > 0) {
                favs.favorites.remove(at: remInd)
                    AudioServicesPlayAlertSound(SystemSoundID(1050))
                }
            }
        }) {
            
            HStack {
            
            Text(rezept.fav ? "Auf der Merkliste" : "Auf Merkliste setzen")
                Image(systemName: rezept.fav ? "heart.fill" : "heart")
            }
        }.foregroundColor(.red)
        .font(.subheadline)
    }
    
    func exportRecipe() {
        let export = RecipeExport(id: rezept.id!, title: rezept.title!, ingredients: rezept.ingredients!, summary: rezept.summary!, instructions: rezept.instructions!, abteilung: rezept.abteilung!, link: rezept.link!)
        
        
        do {
            let jsonData = try JSONEncoder().encode(export)
            print(jsonData)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString) // [{"sentence":"Hello world","lang":"en"},{"sentence":"Hallo Welt","lang":"de"}]
            items.removeAll()
            
            
            sharedSheet = true
            let dir: NSString = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first! as NSString
                
                do {
                    try jsonString.write(toFile: "\(dir)/\(rezept.title!)-\(rezept.id!).json", atomically: true, encoding: String.Encoding.utf16)
                    print("SUCCESS WRITTEN")
                    print(dir)
                    let urlFile = NSURL(fileURLWithPath: "\(dir)/\(rezept.title!)-\(rezept.id!).json")
                    

                    // Create the Array which includes the files you want to share
                    var filesToShare = [Any]()

                    // Add the path of the file to the Array
                    filesToShare.append(urlFile)

                    // Make the activityViewContoller which shows the share-view
                   

                    // Show the share-view
                    let av = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
                    UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)

                } catch {
                    print(error)
                    print(error.localizedDescription)
                }
            
            
            // and decode it back
//            let decodedSentences = try JSONDecoder().decode([Sentence].self, from: jsonData)
//            print(decodedSentences)
        } catch {
            print(error)
            AudioServicesPlayAlertSound(SystemSoundID(1053))
        }
    }
    
   
    
}

struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}


struct DetailView_Previews: PreviewProvider {
    
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
        rezept.instructions = "\nHIIIIIIII\n"
        
        
        return NavigationView{
            DetailView(rezept: rezept)
                .environmentObject(Favs())
        }
    }
}
