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

public class BaseModel : NSObject, MappableBase {
    
    required public override init() { super.init() }
    
    public static func newInstance(json: Json, context: Context) throws -> Self {
        let map = Map(json: json, context: context)
        let new = self.init()
        try new.sequence(map)
        return new
    }
    
    public func sequence(map: Map) throws { fatalError("override me!") }
}