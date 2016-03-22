//
//  LoggerInterceptor.swift
//  RestClient
//
//  Created by Guizion Labs on 11/03/16.
//  Copyright © 2016 Guizion Labs. All rights reserved.
//

import Foundation
import Alamofire
import Genome


class LoggerInterceptor : Interceptor {
    
    weak var bodyParams: AnyObject?
    
    required init() {}
    
    func requestInterceptor<T: MappableBase>(api: API<T>) {
        self.bodyParams = api.bodyParams
    }
    
    func responseInterceptor<T: MappableBase>(api: API<T>, response: Alamofire.Response<AnyObject, NSError>) {
        
        if let _ = response.result.value {
            
            if response.response?.statusCode >= 200 && response.response?.statusCode <= 399 {
                self.logSucess(api, response: response)
            }else{
                self.logError(api, response: response)
            }
        
        }else{
            self.logError(api, response: response)
        }
        
    }

    func logSucess<T: MappableBase>(api: API<T>, response: Alamofire.Response<AnyObject, NSError>){
        api.logger.info("==============================================================================")
        api.logger.info("request URI: \(response.request!.HTTPMethod!) \(response.request!.URLString)")
        api.logger.info("request headers:\n\(response.request!.allHTTPHeaderFields!)")
        
        if let bodyParams = self.bodyParams {
            api.logger.info("request body:\n\(bodyParams)")
        }
        
        api.logger.info("==============================================================================")
        api.logger.info("response status code: \(response.response!.statusCode)")
        api.logger.info("response headers:\n\(response.response!.allHeaderFields)")
        if let value = response.result.value {
            api.logger.info("response body:\n\(value)")
        }
        api.logger.info("==============================================================================")
    }
    
    func logError<T: MappableBase>(api: API<T>, response: Alamofire.Response<AnyObject, NSError>) {
        api.logger.error("==============================================================================")
        api.logger.error("request URI: \(response.request!.HTTPMethod!) \(response.request!.URLString)")
        api.logger.error("request headers:\n\(response.request!.allHTTPHeaderFields!)")
        if let bodyParams = self.bodyParams {
            api.logger.info("request body:\n\(bodyParams)")
        }
        api.logger.error("==============================================================================")
        api.logger.error("response status code: \(response.response!.statusCode)")
        api.logger.error("response headers:\n\(response.response!.allHeaderFields)")
        if let value = response.result.value {
            api.logger.error("response body:\n\(value)")
        }
        api.logger.error("==============================================================================")
    }
}