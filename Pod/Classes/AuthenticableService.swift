//
//  AuthenticableService.swift
//  Pods
//
//  Created by Vithorio Polten on 3/25/16.
//  Base on Tof Template
//
//

import Foundation
import Genome

public class AuthenticableService<Auth: Authentication, R: Routable> : Service<R>, Authenticable {
    var authenticator = Auth()
    
    public func getAuthenticator() -> Auth {
        return authenticator
    }
    
    override public func call<E: MappableBase>(routes: R, type: E.Type, onSuccess: (result: E?) -> Void, onError: (ErrorType?) -> Void, always: () -> Void) throws {
        
        let builder = try routes.builder(base, type: E.self)
        
        if routes.rule.isAuthenticable && authenticator.getToken() == nil {
            throw AuthenticationRequired()
        }
        
        builder.addInterceptor(authenticator)
        
        if (interceptors != nil) {
            builder.addInterceptors(interceptors!)
        }
        
        builder.build().execute(onSuccess, onError: onError, always: always)
        //        rule.builder(base, type: rule.rule.responseType!, authInterceptor: authenticator)
    }
}