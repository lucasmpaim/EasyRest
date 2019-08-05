//
//  CancelationToken.swift
//  Alamofire
//
//  Created by Lucas Paim on 31/07/19.
//

import Foundation
import Alamofire

open class CancelationToken <T> where T: Codable {
    
    weak var request: Request?
    weak var api: API<T>?
    
    open func cancel() {
        api?.cancelled = true
        request?.cancel()
    }
    
}
