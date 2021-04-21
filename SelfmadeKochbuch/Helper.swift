//
//  Helper.swift
//  Kochbuch
//
//  Created by Nico Petersen on 01.03.21.
//

import UIKit

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String) ->T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("FAILED1")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("FAILED2")
        }
        let decoder = JSONDecoder()
        
        do {let loaded = try? decoder.decode(T.self, from: data)
            return loaded!
        }
        catch {
            fatalError("FAILED3")
        }
        
       
        
        
    }
}
