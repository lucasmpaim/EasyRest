//
//  Logger.swift
//  RestClient
//
//  Created by Guizion Labs on 10/03/16.
//  Copyright © 2016 Guizion Labs. All rights reserved.
//

import Foundation


public struct Logger : Loggable {

    public static var isAppCode: Bool = false
    public var logLevel: LogLevel = .verbose

    public var infoIcon = "⚪️"
    public var warningIcon = "🔵"
    public var errorIcon = "🔴"
    
    public init() {}
    
    public func info<T>(_ object: T) {

        if logLevel == .verbose || logLevel == .info {
            if Logger.isAppCode {
                print("\u{1b}[37m\(object)\u{1b}[39m")
            } else {
                print("\(infoIcon)\(object)")
            }
        }
    }
    
    public func warning<T>(_ object: T) {
        if logLevel == .warning || logLevel == .verbose {
            if Logger.isAppCode {
                print("\u{1b}[93m\(object)\u{1b}[39m")
            } else {
                print("\(warningIcon)\(object)")
            }
        }
    }
    
    public func error<T>(_ object: T) {
        if logLevel == .error || logLevel == .verbose {
            if Logger.isAppCode {
                print("\u{1b}[31m\(object)\u{1b}[39m")
            } else {
                print("\(errorIcon)\(object)")
            }
        }
    }
}
