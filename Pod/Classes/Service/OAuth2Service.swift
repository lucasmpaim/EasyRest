//
//  OAuth2Service.swift
//  Pods
//
//  Created by Guizion Labs on 29/03/16.
//
//

import Foundation
import Genome


public enum OAuth2Rotable: Routable {
    
    case loginWithPassword(username: String, password: String)
    case refreshToken(token: String)
    case convertToken(token: String, backend: String)

    public var rule: Rule {
        switch self {
            case let .loginWithPassword(username, password):
                return Rule(method: .post, path: "/token/", isAuthenticable: false, parameters: [
                        ParametersType.query : [
                                "username": username,
                                "password": password,
                                "grant_type": "password"]
                ])

            case let .refreshToken(token):
                return Rule(method: .post, path: "/token/", isAuthenticable: false, parameters: [ParametersType.query: ["token": token]])

            case let .convertToken(token, backend):
                return Rule(method: .post, path: "/convert-token/", isAuthenticable: false, parameters: [
                        ParametersType.query : [
                                "token": token,
                                "backend": backend,
                                "grant_type": "convert_token"]
                ])
        }
    }
}


open class OAuth2Service<T: OAuth2>: AuthenticableService<T, OAuth2Rotable> {

    public override init() {
        super.init()
    }

    open override func builder<T : NodeInitializable>(_ routes: OAuth2Rotable, type: T.Type) throws -> APIBuilder<T> {
        let builder = try super.builder(routes, type: type)
        return builder
    }
}
