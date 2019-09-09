//
//  PromiseService.swift
//  Alamofire
//
//  Created by Lucas Paim on 08/09/19.
//

import Foundation
import PromiseKit


public extension Service where R : Routable {
    
    func call<E>(_ routes: R, type: E.Type) throws -> PromiseResponse<E> where E : Decodable, E : Encodable {
        
        let token = CancelationToken<E>()
        let builder = try self.builder(routes, type: type)
                                .cancelToken(token: token)
                                .build()
        return PromiseResponse(promise: Promise { seal in
            builder.execute({ response in
                seal.fulfill(response)
            }, onError: { error in
                seal.reject(error ?? RestError(rawValue: RestErrorType.unknow.hashValue))
            }, always: {
                // unnecessary method when using PromiseKit
            })
        }, cancelToken: token)
    }
    
    func upload<E>(_ routes: R, type: E.Type, onProgress: @escaping (Float) -> Void) throws -> PromiseResponse<E> where E : Decodable, E : Encodable {
        
        let builder = try self.builder(routes, type: type)
            .build()
        
        return PromiseResponse(promise: Promise { seal in
            
            builder.upload(
                onProgress,
                onSuccess: { response in
                    seal.fulfill(response)
                },
                onError: { error in
                    seal.reject(error ?? RestError(rawValue: RestErrorType.unknow.hashValue))
                },
                always: {}
            )
            
        }, cancelToken: nil)
    }
    
}
