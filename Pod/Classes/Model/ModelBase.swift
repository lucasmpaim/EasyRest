//
//  ModelBase.swift
//  RestClient
//
//  Created by Guizion Labs on 11/03/16.
//  Copyright © 2016 Guizion Labs. All rights reserved.
//

import Foundation
import Genome
import PureJsonSerializer

class BaseModel : MappableBase {
    
    required init() {}
    
    static func newInstance(json: Json, context: Context) throws -> Self {
        let map = Map(json: json, context: context)
        let new = self.init()
        try new.sequence(map)
        return new
    }
    
    func sequence(map: Map) throws { fatalError("override me!") }
}

class UserTest : BaseModel {
    
    var id: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var photo: String?
    var password: String?
    var paypal: String?
    
    override func sequence(map: Map) throws {
        try self.id <~> map["id"]
        try self.firstName <~> map["first_name"]
        try self.lastName <~> map["last_name"]
        try self.email <~> map["email"]
        try self.photo <~> map["photo"]
        try self.password ~> map["password"]
        try self.paypal <~> map["paypal"]
    }
    
}
