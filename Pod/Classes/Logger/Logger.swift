//
//  Logger.swift
//  RestClient
//
//  Created by Guizion Labs on 10/03/16.
//  Copyright © 2016 Guizion Labs. All rights reserved.
//

import Foundation
import SwiftyBeaver


public struct Logger {

    public static var isAppCode: Bool = false
    
    public static var logInXCode = true
    
    public static var logToFile = false
    
    public static var logToCloud = false
    public static var appId: String?
    public static var appSecret: String?
    public static var encryptationKey: String?
    
    public static var swiftyBeaverFormat = "$C$DHH:mm:ss$d $T $N.$F():$l $L: $M$c"
    
    public static let log = SwiftyBeaver.self
    
    
    public enum LogLevel {
        case none
        case info
        case warning
        case error
        case verbose
    }
    
    init() {
        if (Logger.logInXCode) {
            let console = ConsoleDestination()
            console.format = Logger.swiftyBeaverFormat
            Logger.log.addDestination(console)
        }
        if (Logger.logToFile) {
            let file = FileDestination()
            file.format = Logger.swiftyBeaverFormat
            Logger.log.addDestination(file)
        }
        
        if (Logger.logToCloud) {
            let cloud = SBPlatformDestination(appID: Logger.appId!, appSecret: Logger.appSecret!,
                                              encryptionKey: Logger.encryptationKey!)
            cloud.format = Logger.swiftyBeaverFormat
            Logger.log.addDestination(cloud)
        }
    }
    
    public var logLevel: LogLevel = .verbose

    public func info<T>(_ object: T) {

        if logLevel == .verbose || logLevel == .info {
            if Logger.isAppCode {
                print("\u{1b}[37m\(object)\u{1b}[39m")
            }
            Logger.log.info("\(object)")
        }
    }
    
    public func warning<T>(_ object: T) {
        if logLevel == .warning || logLevel == .verbose {
            if Logger.isAppCode {
                print("\u{1b}[93m\(object)\u{1b}[39m")
            }
            Logger.log.warning("\(object)")
        }
    }
    
    public func error<T>(_ object: T) {
        if logLevel == .error || logLevel == .verbose {
            if Logger.isAppCode {
                print("\u{1b}[31m\(object)\u{1b}[39m")
            }
            Logger.log.error("\(object)")
        }
    }
}
