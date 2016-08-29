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
import Genome



let oauth2Authenticator = OAuth2Authenticator()
let BASE_URL = "http://jsonplaceholder.typicode.com"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        //        oauth2Authenticator.interceptors = [DefaultHeadersInterceptor()]
        //        oauth2Authenticator.loginWithPassword("abcd@abcd.com", password: "abcd@abcd", onSucess: {
        //            try! TestRoute.Me.builder(UserTest.self).build().execute({ (result) -> Void in
        //
        //                }, onError: { (error) -> Void in
        //
        //                }, always: { () -> Void in
        //
        //            })
        //            }, onError: { error in
        //
        //            }, always: {
        //        })
        
        
//        try! Apis.Placeholder.Postes.builder(BASE_URL, type: [Posts].self, authInterceptor: oauth2Authenticator).build().execute({ (result) in
//            
//            }, onError: { (error) in
//                
//            }, always: {
//        })
        
        let service = PlaceholderService()

        Logger.isAppCode = true

//        try! service.call(.Me, type: UserTest.self, onSuccess: { (result) in
//            result?.firstName
//            }, onError: { (error) in
//                
//            }, always: {
//        })
        
        service.me({ (result) in
            result?.firstName
            }, onError: { (error) in
                
            }, always: {
        })
        
//        let service2 = Apis.Placeholder.Service()
//        try! service2.call(.Postes, type: UserTest.self, onSucess: { (result) in
//            
//            }, onError: { (error) in
//                
//            }, always: {
//        })
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

public class OAuth2Service<R: Routable> : AuthenticableService<OAuth2Authenticator, R> {
    public override init() { super.init() }
}


final class Apis {
    enum Placeholder: Routable {
        case Me
        case Postes
        
        var rule: Rule {
            switch(self) {
            case .Me:
                let parameters : [ParametersType: AnyObject] = [:]
                return Rule(method: .GET, path: "/api/v1/users/me/", isAuthenticable: true, parameters: parameters)
            case .Postes:
                let parameters : [ParametersType: AnyObject] = [:]
                return Rule(method: .GET, path: "/posts/", isAuthenticable: false, parameters: parameters)
            }
        }
        
        // Alternative
//        class Service : OAuth2Service<Apis.Placeholder> {
//            override var base: String { return BASE_URL }
//            override var interceptors: [Interceptor] { return [DefaultHeadersInterceptor()] }
//            
//            override init() {
//                super.init()
//                authenticator.token = Token()
//                authenticator.token?.accessToken = "MY TOKEN"
//            }
//        }
    }
}

// Alternative
class PlaceholderService : OAuth2Service<Apis.Placeholder> {
    override var base: String { return BASE_URL }
    override var interceptors: [Interceptor] { return [DefaultHeadersInterceptor()] }
    
    override init () {
        super.init()
        getAuthenticator().token = Token()
        getAuthenticator().token?.accessToken = "MY TOKEN"
    }
    
    func me(onSuccess: (result: UserTest?) -> Void, onError: (ErrorType?) -> Void, always: () -> Void) {
        try! call(.Me, type: UserTest.self, onSuccess: onSuccess, onError: defaultErrorHandler(onError), always: always)
    }
    
    func posts(onSuccess: (result: Posts?) -> Void, onError: (ErrorType?) -> Void, always: () -> Void) {
        try! call(.Postes, type: Posts.self, onSuccess: onSuccess, onError: defaultErrorHandler(onError), always: always)
    }
    
    func defaultErrorHandler(onError: (ErrorType?) -> Void) -> (ErrorType?) -> Void {
        return { error in
            /* Do whatever is default for all errors, like
                switch error.cause {
                    case .InternetConnection:
                        // backOff()
                    case .FailedJsonSerialization:
                        Crashlytics.sendEvent(error....)
                        Sentry.captureEvent(...)
                }
            */
            
            onError(error)
        }
    }
}


class Token : BaseModel {
    
    var accessToken: String?
    var refreshToken: String?
    var expiresIn: Int?
    
    override func sequence(map: Map) throws {
        try self.accessToken <~> map["access_token"]
        try self.refreshToken <~> map["refresh_token"]
        try self.expiresIn <~> map["expires_in"]
    }
    
    override var description: String {
        return "token: \(accessToken)\nrefresh token: \(self.refreshToken)"
    }
    
}

class DefaultHeadersInterceptor : Interceptor {
    
    required init() {}
    
    func requestInterceptor<T: JsonConvertibleType>(api: API<T>) {
        
        if api.path.URLString.rangeOfString("http://54.84.75.111/oauth/token/") != nil {
            api.headers["Content-Type"] = "application/x-www-form-urlencoded"
        }else{
            api.headers["Content-Type"] = "application/json"
        }
        api.headers["Accept"] = "application/json"
        api.headers["Device-Token"] = "8ec3bba7de23cda5e8a2726c081be79204faede67529e617b625c984d61cf5c1"
        api.headers["Device-Agent"] = "iOS_SANDBOX"
        api.headers["Accept-Language"] = "pt-br"
    }
    
    func responseInterceptor<T: JsonConvertibleType>(api: API<T>, response: Alamofire.Response<AnyObject, NSError>) {
        
    }
    
    
}


class OAuth2Authenticator : OAuth2, HasToken {
    
    typealias tokenType = Token
    private var token: tokenType?
    
    required init() { }
    
    var interceptor: AuthenticatorInterceptor = OAuth2Interceptor()
    
    func getToken() -> String? {
        if token?.accessToken != nil {
            return "Bearer \(token!.accessToken!)"
        }
        return nil
    }
    
    func saveToken(obj: tokenType) {
        self.token = obj
    }
    
    func getRefreshToken() -> String? {
        return nil
    }
    
    func getExpireDate() -> NSDate? {
        return nil
    }
    
    func getTokenEndPoint() -> String {
        return "http://xpto.com/oauth/token/"
    }
    
    var clientId: String {get{return "Wuy9rbnzO7LKxwjucS26hZIDkU41kSb5UVm9fqI9"}}
    var clientSecret: String {get{return "SgxYobKwqhiMLdCwlk6YQ5y8FDtbUqaZEr3aUVsdkNtlxUISsy73ZO09ljAyWH7Gf3sgi3oEjpihscsMAbd6JQHSt6tNuAI1IaFRfnAhs4pjZB5R1ns4EhKOaajv2ZoC"}}
    
}


class OAuth2Interceptor: AuthenticatorInterceptor {
    required init() { }
    var token: HasToken { return oauth2Authenticator }
    
    func requestInterceptor<T : JsonConvertibleType>(api: API<T>) {
        api.bodyParams?["client_id"] = oauth2Authenticator.clientId
        api.bodyParams?["client_secret"] = oauth2Authenticator.clientSecret
    }

    func responseInterceptor<T: JsonConvertibleType>(api: API<T>, response: Alamofire.Response<AnyObject, NSError>) {

    }
}


class UserTest : BaseModel {
    
    var id: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var photo: String?
    var password: String?
    
    override func sequence(map: Map) throws {
        try self.id <~> map["id"]
        try self.firstName <~> map["first_name"]
        try self.lastName <~> map["last_name"]
        try self.email <~> map["email"]
        try self.photo <~> map["photo"]
        try self.password ~> map["password"]
    }
    
}



class Posts : BaseModel {
    
    var id: Int?
    var userId: Int?
    var title: String?
    var body: String?
    
    override func sequence(map: Map) throws {
        try self.id <~> map["id"]
        try self.userId <~> map["userId"]
        try self.title <~> map["title"]
        try self.body <~> map["body"]
    }
    
}