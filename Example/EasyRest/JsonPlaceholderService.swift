//
//  JsonPlaceholderService.swift
//  EasyRest_Example
//
//  Created by Ráfagan Abreu on 11/09/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import EasyRest

// Interacts with API calls
class JsonPlaceholderService : Service<JsonPlaceholderRoutable> {
    // Must define base URL
    // It's the base URL for endpoints defined in Routable
    // Tip: Don't put a slash at the end (/)
    override public var base: String { return "https://jsonplaceholder.typicode.com" }
    
    // Optionally you can define interceptors
    // EasyRest will add some nice ones for you by default (like CurlInterceptor)
    // override var interceptors: [Interceptor]? { return [YourInterceptor()] }
    
    // Tip: You can create custom ways to handle this Service logs and Alamofire
    // overriding other Service features, like call, upload, loggerLevel and so on...
}
