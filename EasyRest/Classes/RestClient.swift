//
//  RestClient.swift
//  RestClient
//
//  Created by Guizion Labs on 09/03/16.
//  Copyright © 2016 Guizion Labs. All rights reserved.
//

import Foundation
import Genome

open class EasyRest {
    
    open static let sharedInstance = EasyRest()
    fileprivate var kServerDefaultEndPoint: String?
    
    open var globalLogClass : Loggable.Type = Logger.self
    
//    func setup(_ defaultServerEndPoint: String) {
//        
//        self.kServerDefaultEndPoint = defaultServerEndPoint
//        
//        ReachabilityCore.sharedInstance.setup()
//    
//        NotificationCenter.default.addObserver(EasyRest.sharedInstance, selector: #selector(didDisconnect),
//            name: NSNotification.Name(rawValue: ReachabilityCore.Notifications.NoNetwork.rawValue), object: nil)
//        
//        NotificationCenter.default.addObserver(EasyRest.sharedInstance, selector: #selector(didConnectWithWifi),
//            name: NSNotification.Name(rawValue: ReachabilityCore.Notifications.Wifi.rawValue), object: nil)
//        
//        NotificationCenter.default.addObserver(EasyRest.sharedInstance, selector: #selector(didConnectWith3G),
//            name: NSNotification.Name(rawValue: ReachabilityCore.Notifications.Mobile.rawValue), object: nil)
//        
//        NotificationCenter.default.addObserver(EasyRest.sharedInstance, selector: #selector(didConnect),
//            name: NSNotification.Name(rawValue: ReachabilityCore.Notifications.Connect.rawValue), object: nil)
//    }
//    
    
    @objc func didConnect(){ }
    @objc func didDisconnect() { }
    @objc func didConnectWithWifi() { }
    @objc func didConnectWith3G() { }
    
}
