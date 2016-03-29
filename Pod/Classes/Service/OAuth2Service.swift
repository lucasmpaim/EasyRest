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
    
    case LoginWithPassword(username: String, password: String)
    case RefreshToken(token: String)
    
    public var rule: Rule {
        switch self {
            case let .LoginWithPassword(username, password):
                return Rule(method: .POST, path: "", isAuthenticable: false, parameters: [ParametersType.Query : ["username": username, "password": password]])
            case let .RefreshToken(token):
                return Rule(method: .POST, path: "", isAuthenticable: false, parameters: [ParametersType.Query: ["token": token]])
        }
    }
}


public class OAuth2Service<T: OAuth2>: AuthenticableService<T, OAuth2Rotable> {

    public override func builder<T : MappableBase>(routes: OAuth2Rotable, type: T.Type) throws -> APIBuilder<T> {
        let builder = try super.builder(routes, type: type)
        builder.addQueryParams(["client_id": authenticator.clientId,
                                "client_secret": authenticator.clientSecret])
        return builder
    }
    
}