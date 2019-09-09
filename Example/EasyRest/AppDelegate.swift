//
//  AppDelegate.swift
//  EasyRest
//
//  Created by Lucas on 03/22/2016.
//  Copyright (c) 2016 Lucas. All rights reserved.
//

import UIKit

import Alamofire
import EasyRest


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Logger.isAppCode = false
        
        EasyRest.sharedInstance.globalLogClass = LoggerBeaver.self
        
        let service2 = Apis.Placeholder.OpenService()
        try! service2.call(.post(id: 1), type: Posts.self)
            .promise
            .done { result in
                print("RESPONSE ITEM ID: \(result?.body?.id)")
            }.catch { error in
                print("Error : \(error)")
            }.finally {
                print("This code will be called all the times")
            }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}


final class Apis {
    enum Placeholder: Routable {
        case post(id: Int)

        var rule: Rule {
            switch(self) {
                case let .post(id):
                    let parameters : [ParametersType: AnyObject] = [:]
                    return Rule(method: .get, path: "/posts/\(id)/", isAuthenticable: false, parameters: parameters)
            }
        }

        // Alternative
        class OpenService : Service<Apis.Placeholder> {
            override var base: String { return "https://jsonplaceholder.typicode.com" }
            override var interceptors: [Interceptor] { return [DefaultHeadersInterceptor()] }
        }
    }
}


//class Token : BaseModel {
//
//    var accessToken: String?
//    var refreshToken: String?
//    var expiresIn: Int?
//
//
//    override func sequence(_ map: Map) throws {
//        try self.accessToken <~> map["access_token"]
//        try self.refreshToken <~> map["refresh_token"]
//        try self.expiresIn <~> map["expires_in"]
//    }
//
//    override var description: String {
//        return "token: \(String(describing: accessToken))\nrefresh token: \(String(describing: self.refreshToken))"
//    }
//
//}

class DefaultHeadersInterceptor : Interceptor {

    required init() {}

    func requestInterceptor<T: Codable>(_ api: API<T>) {
        api.headers["Content-Type"] = "application/json"
        api.headers["Accept"] = "application/json"
        api.headers["Device-Token"] = "8ec3bba7de23cda5e8a2726c081be79204faede67529e617b625c984d61cf5c1"
        api.headers["Device-Agent"] = "iOS_SANDBOX"
        api.headers["Accept-Language"] = "pt-br"
    }

    func responseInterceptor<T: Codable>(_ api: API<T>, response: DataResponse<Any>) {

    }


}


//class OAuth2Authenticator : OAuth2, HasToken {
//
//    typealias tokenType = Token
//    fileprivate var token: tokenType?
//
//    required init() { }
//
//    var interceptor: AuthenticatorInterceptor = OAuth2Interceptor()
//
//    func getToken() -> String? {
//        if token?.accessToken != nil {
//            return "Bearer \(token!.accessToken!)"
//        }
//        return nil
//    }
//
//    func saveToken(_ obj: tokenType) {
//        self.token = obj
//    }
//
//    func getRefreshToken() -> String? {
//        return nil
//    }
//
//    func getExpireDate() -> Date? {
//        return nil
//    }
//
//    func getTokenEndPoint() -> String {
//        return "http://54.173.184.165/api/oauth/token/"
//    }
//
//    var clientId: String {get{return "HnLQdrUlWY67sxM7Jr4k25Zd8aFZLQeErXQu4iP3"}}
//    var clientSecret: String {get{return "L7tbawRqldwMA9GndpzoUMMhz2lQfnhPQF8v5oTRli3nraoY0rJD6rjfapgStUupszgMKMyh7nFnfqKf29LLwzpWMfzbhdLLReheDKks2c59ZCDYfhyEXT6TuwRbEFg2"}}
//
//}
//
//
//
//class ExampleOAuth2Service: OAuth2Service<OAuth2Authenticator> {
//
//    override var base: String {return "http://54.173.184.165/api/oauth/token/"}
//    override var interceptors: [Interceptor]? {return [DefaultHeadersInterceptor()]}
//    override var loggerLevel: LogLevel { return .none }
//
//    func loginWithPassword(_ email: String, password: String, onSuccess: @escaping (Token) -> Void, onError: @escaping  (RestError?) -> Void, always: @escaping () -> Void) {
//
//        try! call(OAuth2Rotable.loginWithPassword(username: email, password: password), type: Token.self, onSuccess: { response in
//            self.getAuthenticator().saveToken(response!.body!)
//            onSuccess(response!.body!)
//        }, onError: onError, always: always)
//    }
//
//    func refreshToken(_ token: String, onSuccess: @escaping () -> Void, onError: @escaping (RestError?) -> Void, always: @escaping () -> Void) {
//        try! call(OAuth2Rotable.refreshToken(token: token), type: Token.self, onSuccess: { response in
//            self.getAuthenticator().saveToken(response!.body!)
//            onSuccess()
//        }, onError: onError, always: always)
//    }
//
//    func defaultErrorHandler(_ onError: @escaping (RestError?) -> Void) -> (RestError?) -> Void {
//        return { error in
//            onError(error)
//        }
//    }
//}
//
//
//class UserTest : BaseModel {
//
//    var id: String?
//    var firstName: String?
//    var lastName: String?
//    var email: String?
//    var photo: String?
//    var password: String?
//
//    override func sequence(_ map: Map) throws {
//        try self.id <~> map["id"]
//        try self.firstName <~> map["first_name"]
//        try self.lastName <~> map["last_name"]
//        try self.email <~> map["email"]
//        try self.photo <~> map["photo"]
//        try self.password ~> map["password"]
//    }
//
//}
//
//class OAuth2Interceptor : AuthenticatorInterceptor {
//
//    required init() {}
//
//    var token: HasToken {
//        return OAuth2Authenticator()
//    }
//
//    func requestInterceptor<T: NodeInitializable>(_ api: API<T>) {
//        if api.path.url!.absoluteString.range(of: OAuth2Authenticator().getTokenEndPoint()) != nil {
//            api.queryParams!["client_id"] = (token as! OAuth2Authenticator).clientId
//            api.queryParams!["client_secret"] = (token as! OAuth2Authenticator).clientSecret
//        }
//
//        if let token = token.getToken() {
//            api.headers["Authorization"] = token
//        }
//    }
//
//    func responseInterceptor<T: NodeInitializable>(_ api: API<T>, response: DataResponse<Any>) {
//
//    }
//
//}


class Posts : Codable {

    var id: Int?
    var userId: Int?
    var title: String?
    var body: String?

}

