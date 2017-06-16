//
//  Logger.swift
//  RestClient
//
//  Created by Guizion Labs on 10/03/16.
//  Copyright © 2016 Guizion Labs. All rights reserved.
//

import Foundation
import SwiftyBeaver


public struct LoggerBeaver : Loggable {
    
    public static var logInIDE = true
    public static var logToFile = false
    public static var logToCloud = false
    public static var appId: String?
    public static var appSecret: String?
    public static var encryptationKey: String?
    
    public static var swiftyBeaverFormat = "$C$DHH:mm:ss$d $T $N.$F():$l $L: $M$c"
    public static let log = SwiftyBeaver.self
    
    public var logLevel: LogLevel = .verbose
    
    public init() {
        if (LoggerBeaver.logInIDE) {
            let console = ConsoleDestination()
            console.format = LoggerBeaver.swiftyBeaverFormat
            LoggerBeaver.log.addDestination(console)
        }
        if (LoggerBeaver.logToFile) {
            let file = FileDestination()
            file.format = LoggerBeaver.swiftyBeaverFormat
            LoggerBeaver.log.addDestination(file)
        }
        
        if (LoggerBeaver.logToCloud) {
            let cloud = SBPlatformDestination(appID: LoggerBeaver.appId!, appSecret: LoggerBeaver.appSecret!,
                                              encryptionKey: LoggerBeaver.encryptationKey!)
            cloud.format = LoggerBeaver.swiftyBeaverFormat
            LoggerBeaver.log.addDestination(cloud)
        }
    }
    
    
    public func info<T>(_ object: T) {
        
        if logLevel == .verbose || logLevel == .info {
            LoggerBeaver.log.info("\(object)")
        }
    }
    
    public func warning<T>(_ object: T) {
        if logLevel == .warning || logLevel == .verbose {
            LoggerBeaver.log.warning("\(object)")
        }
    }
    
    public func error<T>(_ object: T) {
        if logLevel == .error || logLevel == .verbose {
            LoggerBeaver.log.error("\(object)")
        }
    }
}
