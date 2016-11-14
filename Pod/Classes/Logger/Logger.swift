//
//  Logger.swift
//  RestClient
//
//  Created by Guizion Labs on 10/03/16.
//  Copyright © 2016 Guizion Labs. All rights reserved.
//

import Foundation


public struct Logger {

    public static var isAppCode: Bool = false
    
    public enum LogLevel {
        case none
        case info
        case warning
        case error
        case verbose
    }
    
    public var logLevel: LogLevel = .verbose

    static let ESCAPE = "\u{001b}[fg"
    static let RESET = ESCAPE + ";"


    public func info<T>(_ object: T) {

        if logLevel == .verbose || logLevel == .info {
            if Logger.isAppCode {
                print("\u{1b}[37m\(object)\u{1b}[39m")
            } else {
                print("\(Logger.ESCAPE)102,102,102;\(object)\(Logger.RESET)")
            }
        }
    }
    
    public func warning<T>(_ object: T) {
        if logLevel == .warning || logLevel == .verbose {
            if Logger.isAppCode {
                print("\u{1b}[93m\(object)\u{1b}[39m")
            } else {
                print("\(Logger.ESCAPE)135,135,0;\(object)\(Logger.RESET)")
            }
        }
    }
    
    public func error<T>(_ object: T) {
        if logLevel == .error || logLevel == .verbose {
            if Logger.isAppCode {
                print("\u{1b}[31m\(object)\u{1b}[39m")
            } else {
                print("\(Logger.ESCAPE)153,0,0;\(object)\(Logger.RESET)")
            }
        }
    }
}
