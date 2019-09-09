//
//  PromiseResponse.swift
//  EasyRest.default-LoggerBeaver-PromiseKit
//
//  Created by Lucas Paim on 08/09/19.
//

import Foundation
import PromiseKit

public struct PromiseResponse <T> where T: Codable {
    let promise: Promise<Response<T>?>
    let cancelToken: CancelationToken<T>?
}
