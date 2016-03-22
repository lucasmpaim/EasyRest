//
//  ReachabilityCore.swift
//  RestClient
//
//  Created by Guizion Labs on 09/03/16.
//  Copyright © 2016 Guizion Labs. All rights reserved.
//

import Foundation
import ReachabilitySwift


public class ReachabilityCore {

    public enum Notifications : String{
        case NoNetwork = "NoNetworkNotification"
        case Wifi = "WifiNotification"
        case Mobile = "MobileNotification"
        case Connect = "Connect"
        case ChangeNetworkState = "ReachabilityChangedNotification"
    }
    
    public static let sharedInstance = ReachabilityCore()
    
    var reachability: Reachability?
    
    public func setup() {
        do{
            self.reachability = try Reachability.reachabilityForInternetConnection()
            
            self.reachability?.whenReachable = { reachability in
                
                NSNotificationCenter.defaultCenter().postNotificationName(Notifications.Connect.rawValue, object: nil)
                
                if reachability.isReachableViaWiFi() {
                    NSNotificationCenter.defaultCenter().postNotificationName(Notifications.Wifi.rawValue, object: nil)
                    
                } else {
                    NSNotificationCenter.defaultCenter().postNotificationName(Notifications.Mobile.rawValue, object: nil)
                }
            }
            
            self.reachability?.whenUnreachable = { reachability in
                NSNotificationCenter.defaultCenter().postNotificationName(Notifications.NoNetwork.rawValue, object: nil)
            }
            
        }catch{
            print("Unable to create Reachability")
            return
        }
    }
    
    public func startMonitoring() {
        do{
            try reachability?.startNotifier()
        }catch{
            print("Unable to create Reachability")
        }
    }
    
    public func stopMonitoring() {
        reachability?.stopNotifier()
    }
    
    public func isWifi() -> Bool? {
        return reachability?.isReachableViaWiFi()
    }
    
    public func isConnected() -> Bool?{
        return reachability?.isReachable()
    }
    
}