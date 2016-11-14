//
//  Errors.swift
//  Pods
//
//  Created by Guizion Labs on 24/08/16.
//
//

import Foundation


public enum RestErrorType: Int {
    
    //MARK: Librarie error's
    case unknow    = 0
    case noNetwork = 1
    case invalidType = 2
    case authenticationRequired = 3
    case formEncodeError = 4

    //MARK: Client HTTP Errors
    case badRequest = 400
    case unauthorized = 401
    case paymentRequired = 402
    case forbbiden = 403
    case notFound = 404
    case methodNotFound = 405
    case notAcceptable = 406
    case proxyAuthenticationRequired = 407
    case requestTimeout = 408
    case conflict = 409
    case gone = 410
    case lengthRequired = 411
    case preconditionFailed = 412
    case payloadTooLarge = 413
    case uriTooLong = 414
    case unsupportedMediaType = 415
    case rangeNotSatisfiable = 416
    case expectationFailed = 417
    case imATeapot = 418
    case misdirectedRequest = 421
    case unprocessableEntity = 422
    case locked = 423
    case failedDependency = 424
    case upgradeRequired = 426
    case preconditionRequired = 428
    case tooManyRequests = 429
    case requestHeaderFieldsTooLarge = 431
    case unavailableForLegalReasons = 451
    
    //Mark: Server HTTP Errors
    case internalServerError = 500
    case notImplemented = 501
    case badGateway = 502
    case serviceUnavailable = 503
    case gatewayTimeout = 504
    case httpVersionNotSupported = 505
    case variantAlsoNegotiates = 506
    case insufficientStorage = 507
    case loopDetected = 508
    case notExtended = 510
    case networkAuthenticationRequired = 511
    
}
