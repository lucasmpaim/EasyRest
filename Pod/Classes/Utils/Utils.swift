//
//  Utils.swift
//  RestClient
//
//  Created by Guizion Labs on 11/03/16.
//  Copyright © 2016 Guizion Labs. All rights reserved.
//

import Foundation
import Alamofire


extension String {
    func removeLastCharacter() -> String {
        return self.substring(to: self.characters.index(before: self.endIndex))
    }
    
    func replacePathLabels(_ dictionary : Dictionary<String, String>) -> String {
        var replacedString = self
        
        for (key, value) in dictionary {
            replacedString = replacedString.replacingOccurrences(of: "{\(key)}", with: value, options: NSString.CompareOptions.literal, range: nil)
        }
        
        return replacedString
    }
}
