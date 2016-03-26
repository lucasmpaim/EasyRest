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
    static func isSuccessfulRequest(response: Alamofire.Response<AnyObject, NSError>) -> Bool {
        return 200...299 ~= response.response?.statusCode
//        return response.response?.statusCode >= 200 && response.response?.statusCode <= 299
    }
}

@warn_unused_result
public func ~=<I : ForwardIndexType where I : Comparable>(pattern: Range<I>, value: I?) -> Bool {
    return value != nil && pattern ~= value!
}

extension String {
    func removeLastCharacter() -> String {
        return self.substringToIndex(self.endIndex.predecessor())
    }
    
    func replacePathLabels(dictionary : Dictionary<String, String>) -> String {
        var replacedString = self
        
        for (key, value) in dictionary {
            replacedString = replacedString.stringByReplacingOccurrencesOfString("{\(key)}", withString: value, options: NSStringCompareOptions.LiteralSearch, range: nil)
        }
        
        return replacedString
    }
}