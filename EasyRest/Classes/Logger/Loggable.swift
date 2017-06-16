//
//  Loggable.swift
//  Pods
//
//  Created by Guizion Labs on 16/06/17.
//
//

import Foundation


public enum LogLevel {
    case none
    case info
    case warning
    case error
    case verbose
}


public protocol Loggable {
    init()
    func info<T>(_ object: T)
    func warning<T>(_ object: T)
    func error<T>(_ object: T)
    var logLevel: LogLevel {get set}
}
