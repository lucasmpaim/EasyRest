//
//  OAuth2Service.swift
//  RestClient
//
//  Created by Guizion Labs on 14/03/16.
//  Copyright © 2016 Guizion Labs. All rights reserved.
//

import Foundation
import Genome

public protocol OAuth2 : Authentication {
    
    func getRefreshToken() -> String?
    func getExpireDate() -> NSDate?
    func getTokenEndPoint() -> String
    
    var clientId: String {get}
    var clientSecret: String {get}
    
    
    var interceptors: [Interceptor] {get set}
}


extension OAuth2 {
    
    public func loginWithPassword(username: String, password: String, onSucess: () -> Void, onError: (error: ErrorType?) -> Void, always: () -> Void) {
        
        let parameters = [
            "username": username,
            "password": password,
            "grant_type": "password",
            "client_secret": self.clientSecret,
            "client_id": self.clientId
        ]
        
        APIBuilder<tokenType>().resource(self.getTokenEndPoint(), method: .POST)
            .addInterceptors(self.interceptors)
            .addQueryParams(parameters)
            .addInterceptors(interceptors)
            .build()
            .execute ({
                result in
                
                self.saveToken(result!)
                onSucess()
                
            }, onError: {
                error in
                
                onError(error: error)
            
            }, always: {
                always()
            })
    }
    
    public func refreshToken() {
        
        let parameters = [
            "client_secret": self.clientSecret,
            "client_id": self.clientId,
            "grant_type": "refresh_token",
            "refresh_token": self.getRefreshToken()!,
        ]
            
        APIBuilder<tokenType>().resource(self.getTokenEndPoint(), method: .POST)
            .addInterceptors(self.interceptors)
            .addQueryParams(parameters)
            .build()
            .execute ({
                result in
                
                self.saveToken(result!)
                
                }, onError: {
                    error in
                    
                }, always: {
                    
            })
    }
    
}