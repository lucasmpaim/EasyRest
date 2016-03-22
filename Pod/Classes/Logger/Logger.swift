//
//  Logger.swift
//  RestClient
//
//  Created by Guizion Labs on 10/03/16.
//  Copyright © 2016 Guizion Labs. All rights reserved.
//

import Foundation


public struct Logger {
    
    
    public enum LogLevel {
        case None
        case Info
        case Warning
        case Error
        case Verbose
    }
    
    public var logLevel: LogLevel = .Verbose
    
    static let ESCAPE = "\u{001b}["
    
    static let RESET_FG = ESCAPE + "fg;"
    static let RESET_BG = ESCAPE + "bg;"
    static let RESET = ESCAPE + ";"
    
    
    public func info<T>(object: T) {
        
        if logLevel == .Verbose || logLevel == .Info {
            print("\(Logger.ESCAPE)fg102,102,102;\(object)\(Logger.RESET)")
        }
        
    }
    
    public func warning<T>(object: T) {
        
        if logLevel == .Warning || logLevel == .Verbose {
            print("\(Logger.ESCAPE)fg135,135,0;\(object)\(Logger.RESET)")
        }
        
    }
    
    public func error<T>(object: T) {
        if logLevel == .Error || logLevel == .Verbose {
            print("\(Logger.ESCAPE)fg153,0,0;\(object)\(Logger.RESET)")
        }
    }
    
}
