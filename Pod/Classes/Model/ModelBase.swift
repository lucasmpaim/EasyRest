//
//  ModelBase.swift
//  RestClient
//
//  Created by Guizion Labs on 11/03/16.
//  Copyright © 2016 Guizion Labs. All rights reserved.
//

import Foundation
import Genome

open class BaseModel : NSObject, MappableBase {
    
    required public override init() { super.init() }
    
    public required convenience init(node: Node, in context: Context = EmptyNode) throws {
        self.init()
        let map = Map(node: node, in: context)
        try self.sequence(map)
    }
    
    open func sequence(_ map: Map) throws { fatalError("override me!") }
}
