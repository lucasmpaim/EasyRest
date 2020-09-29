//
//  AuthenticableService.swift
//  Pods
//
//  Created by Vithorio Polten on 3/25/16.
//  Base on Tof Template
//
//

import Foundation


open class AuthenticableService<Auth: Authentication, R: Routable> : Service<R>, Authenticable {
    var authenticator = Auth()
    
    public override init() { super.init() }

    open func getAuthenticator() -> Auth {
        return authenticator
    }
    
    open override func builder<T : Codable>(_ routes: R, type: T.Type) throws -> APIBuilder<T> {
        let builder = try super.builder(routes, type: type)
        
        _ = builder.addInterceptor(authenticator.interceptor)
        
        return builder
    }
    
    override open func call<E: Codable>(_ routes: R, type: E.Type, onSuccess: @escaping (Response<E>?) -> Void, onError: @escaping (RestError?) -> Void, always: @escaping () -> Void) throws -> CancelationToken<E> {
        
        let builder = try self.builder(routes, type: type)
        
        if routes.rule.isAuthenticable && authenticator.getToken() == nil {
            throw RestError(rawValue: RestErrorType.authenticationRequired.rawValue)
        }
        let token = CancelationToken<E>()
        builder.cancelToken(token: token).build().execute(onSuccess, onError: onError, always: always)
        return token
    }

    override open func upload<E: Codable>(_ routes: R, type: E.Type,
                                        onProgress: @escaping (Float) -> Void,
                                        onSuccess: @escaping (Response<E>?) -> Void,
                                        onError: @escaping (RestError?) -> Void,
                                        always: @escaping () -> Void) throws {
        let builder = try self.builder(routes, type: type)

        if routes.rule.isAuthenticable && authenticator.getToken() == nil {
            throw RestError(rawValue: RestErrorType.authenticationRequired.rawValue)
        }

        builder.build().upload(
                onProgress,
                onSuccess: onSuccess,
                onError: onError,
                always: always)
    }
}
