//
//  PromiseResponse.swift
//  EasyRest.default-LoggerBeaver-PromiseKit
//
//  Created by Lucas Paim on 08/09/19.
//

import Foundation
import PromiseKit

public struct PromiseResponse <T> where T: Codable {
    public let promise: Promise<Response<T>?>
    public let cancelToken: CancelationToken<T>?
}
