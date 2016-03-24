//
//  RestClient.swift
//  RestClient
//
//  Created by Guizion Labs on 09/03/16.
//  Copyright © 2016 Guizion Labs. All rights reserved.
//

import Foundation
import Genome

public class EasyRest {
    
    public static let sharedInstance = EasyRest()
    private var kServerDefaultEndPoint: String?
    
    func setup(defaultServerEndPoint: String) {
        
        self.kServerDefaultEndPoint = defaultServerEndPoint
        
        ReachabilityCore.sharedInstance.setup()
    
        NSNotificationCenter.defaultCenter().addObserver(EasyRest.sharedInstance, selector: #selector(didDisconnect),
            name: ReachabilityCore.Notifications.NoNetwork.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(EasyRest.sharedInstance, selector: #selector(didConnectWithWifi),
            name: ReachabilityCore.Notifications.Wifi.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(EasyRest.sharedInstance, selector: #selector(didConnectWith3G),
            name: ReachabilityCore.Notifications.Mobile.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(EasyRest.sharedInstance, selector: #selector(didConnect),
            name: ReachabilityCore.Notifications.Connect.rawValue, object: nil)
    }
    
    
    @objc func didConnect(){ }
    @objc func didDisconnect() { }
    @objc func didConnectWithWifi() { }
    @objc func didConnectWith3G() { }
    
}