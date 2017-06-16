//
//  OAuth2Service.swift
//  RestClient
//
//  Created by Guizion Labs on 14/03/16.
//  Copyright © 2016 Guizion Labs. All rights reserved.
//

import Foundation
import Genome

public protocol OAuth2 : Authentication {
    
    func getRefreshToken() -> String?
    func getExpireDate() -> Date?
    func getTokenEndPoint() -> String
    
    var clientId: String {get}
    var clientSecret: String {get}
}
