//
//  Utils.swift
//  RestClient
//
//  Created by Guizion Labs on 11/03/16.
//  Copyright © 2016 Guizion Labs. All rights reserved.
//

import Foundation
import Alamofire


class Utils {
    static func isSucessRequest(response: Alamofire.Response<AnyObject, NSError>) -> Bool {
        return response.response?.statusCode >= 200 && response.response?.statusCode <= 299
    }
}

extension String {
    public func removeLastCharacter() -> String {
        return self.substringToIndex(self.endIndex.predecessor())
    }
    
    public func replaceLabels(dictionary : Dictionary<String, String>) -> String {
        var replacedString = self
        
        dictionary.keys.forEach { (key) -> () in
            replacedString = replacedString.stringByReplacingOccurrencesOfString(key, withString: dictionary[key]!, options: NSStringCompareOptions.LiteralSearch, range: nil)
            
        }
        return replacedString
    }
}