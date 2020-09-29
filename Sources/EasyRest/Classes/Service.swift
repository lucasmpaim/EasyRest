//
//  Service.swift
//  Pods
//
//  Created by Vithorio Polten on 3/25/16.
//  Base on Tof Template
//
//
import Foundation

open class Service<R> where R: Routable {
    
    public init() { }
    
    open var interceptors: [Interceptor]? {return nil}
    
    open var loggerLevel: LogLevel {
        return .verbose
    }
    
    open var loggerClass: Loggable.Type {
        return EasyRest.sharedInstance.globalLogClass
    }
    
    open var base: String {
        get {
            fatalError("Override to provide baseUrl")
        }
    }
    
    open func builder<T: Codable>(_ routes: R,
                                  type: T.Type) throws -> APIBuilder<T> {
        let builder = try routes.builder(base, type: type)
        builder.logger = self.loggerClass.init()
        builder.logger?.logLevel = self.loggerLevel
        if (interceptors != nil) {
            _ = builder.addInterceptors(interceptors!)
        }
        return builder
    }
    
    open func call<E: Codable>(_ routes: R,
                               type: E.Type,
                               onSuccess: @escaping (Response<E>?) -> Void,
                               onError: @escaping (RestError?) -> Void,
                               always: @escaping () -> Void) throws -> CancelationToken<E> {
        let token = CancelationToken<E>()
        try builder(routes, type: type)
            .cancelToken(token: token)
            .build()
            .execute(onSuccess, onError: onError, always: always)
        return token
    }
    
    open func upload<E: Codable>(_ routes: R, type: E.Type,
                                 onProgress: @escaping (Float) -> Void,
                                 onSuccess: @escaping (Response<E>?) -> Void,
                                 onError: @escaping (RestError?) -> Void,
                                 always: @escaping () -> Void) throws {
        try builder(routes, type: type)
            .build()
            .upload(
                onProgress,
                onSuccess: onSuccess,
                onError: onError,
                always: always
        )
    }
    
    open func download(_ routes: R,
                       onProgress: @escaping (Float) -> Void,
                       onSuccess: @escaping (Response<Data>?) -> Void,
                       onError: @escaping (RestError?) -> Void,
                       always: @escaping () -> Void) throws {
        try builder(routes, type: Data.self)
            .build()
            .download(
                onProgress,
                onSuccess: onSuccess,
                onError: onError,
                always: always
        )
    }
}

