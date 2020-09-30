//
//  Authenticable.swift
//  Pods
//
//  Created by Vithorio Polten on 3/25/16.
//  Base on Tof Template
//
//

import Foundation

protocol Authenticable {
    associatedtype AuthType: Authentication
    
    var authenticator: AuthType { get set }
}