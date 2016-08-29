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
    
    public override init() { super.init() }

    public func getAuthenticator() -> Auth {
        return authenticator
    }
    
    public override func builder<T : MappableBase>(routes: R, type: T.Type) throws -> APIBuilder<T> {
        let builder = try super.builder(routes, type: type)
        
        builder.addInterceptor(authenticator.interceptor)
        
        if (interceptors != nil) {
            builder.addInterceptors(interceptors!)
        }
        
        return builder
    }
    
    override public func call<E: MappableBase>(routes: R, type: E.Type, onSuccess: (result: E?) -> Void, onError: (RestError?) -> Void, always: () -> Void) throws {
        
        let builder = try self.builder(routes, type: type)
        
        if routes.rule.isAuthenticable && authenticator.getToken() == nil {
            throw RestError(rawValue: RestErrorType.AuthenticationRequired.rawValue)
        }
        
        builder.build().execute(onSuccess, onError: onError, always: always)
    }

    override public func upload<E: MappableBase>(routes: R, type: E.Type,
                                        onProgress: (progress: Float) -> Void,
                                        onSuccess: (result: E?) -> Void,
                                        onError: (RestError?) -> Void,
                                        always: () -> Void) throws {
        let builder = try self.builder(routes, type: type)

        if routes.rule.isAuthenticable && authenticator.getToken() == nil {
            throw RestError(rawValue: RestErrorType.AuthenticationRequired.rawValue)
        }

        builder.build().upload(
                onProgress,
                onSuccess: onSuccess,
                onError: onError,
                always: always)
    }
}