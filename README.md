 ![](https://github.com/lucasmpaim/EasyRest/blob/master/Images/logo.png)
 
 
 [![Build Status](https://www.bitrise.io/app/26434cc1ea3414c5/status.svg?token=DtKIwnE_HhoEyWPnAF6nhw)](https://www.bitrise.io/app/26434cc1ea3414c5)

# Motivation
After reviewing many REST clients for iOS , we realize that all are very verbose , which is unnecessary.
This library was born from the need to simplify the communication between client and server.

## Requirements
 - Swift 3

For Swift 2.2 and 2.3 check the branches.

## Logger
The EasyRest integrate the [SwiftyBeaver](http://swiftybeaver.com/) Logger system
 ```swift

  // For log in XCode console
  Logger.logInXCode = true

  Logger.logToFile = false

  // Cloud config
  Logger.logToCloud = false
  Logger.appId: String?
  Logger.appSecret: String?
  Logger.encryptationKey: String?

  Logger.swiftyBeaverFormat = "$C$DHH:mm:ss$d $T $N.$F():$l $L: $M$c"

  // SwiftyBeaver log reference
  Logger.log = SwiftyBeaver.self

 ```
 ### For AppCode
 - Grep Console
 - Enable ANSI colors in Grep Console
 - Add the following to your AppDelegate
 
 ```swift
 Logger.isAppCode = true
 ```

## Documentation
You can read the doc's in this [wiki](https://github.com/lucasmpaim/EasyRest/wiki)

## Usage
To add EasyRest to your project, add the following in your podfile

```Ruby
pod 'EasyRest', :git => 'https://github.com/lucasmpaim/EasyRest.git'
```

## Model Example:
```swift
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
class Post : BaseModel {

    var id: String?
    var title: String?

    override func sequence(map: Map) throws {
        try self.id <~> map["id"]
        try self.title <~> map["title"]
    }
}
```

## Route Example:
```swift

enum TestRoute: Routable{

    case Me(String)
    case Post(String)

    var rule: Rule {
        switch(self) {
            case let .Me(name):
                return Rule(method: .GET, path: "/api/v1/users/me/", isAuthenticable: true, parameters: [.Query : ["name": name]])
            case let .Post(id):
                let parameters : [ParametersType: AnyObject] = [:]
                return Rule(method: .GET, path: "/api/v1/posts/\(id)/", isAuthenticable: true, parameters: parameters)
            }
    }

}

```

## Service Example
```swift

class TestRouteService : OAuth2Service<TestRoute> {
    override var base: String { return BASE_URL }
    override var interceptors: [Interceptor] { return [DefaultHeadersInterceptor()] }
    
    convenience init() {
        self.init()
    }
    
    func me(name: String, onSuccess: (result: Response<UserTest>?) -> Void, onError: (ErrorType?) -> Void, always: () -> Void) {
        try! call(.Me(name), type: UserTest.self, onSuccess: onSuccess, onError: defaultErrorHandler(onError), always: always)
    }
    
    func post(id: Int, onSuccess: (result: Response<Post>?) -> Void, onError: (ErrorType?) -> Void, always: () -> Void) {
        try! call(.Post(id), type: Post.self, onSuccess: onSuccess, onError: defaultErrorHandler(onError), always: always)
    }
    
    func defaultErrorHandler(onError: (ErrorType?) -> Void) -> (ErrorType?) -> Void {
        return { error in
            /* Do whatever is default for all errors, like
                switch error.cause {
                    case .InternetConnection:
                        // backOff()
                    case .FailedJsonSerialization:
                        Crashlytics.sendMessage(error....)
                        Sentry.captureEvent(...)
                }
            */
            
            onError(error)
        }
    }
}
```


## Interceptor Example:

```swift
class CurlInterceptor: Interceptor {

    required init() {}

    func requestInterceptor<T: MappableBase>(api: API<T>) {}

    func responseInterceptor<T: MappableBase>(api: API<T>, response: Alamofire.Response<AnyObject, NSError>) {
        if Utils.isSuccessfulRequest(response) {
            api.logger.info("\(api.curl!)")
        }else{
            api.logger.error("\(api.curl!)")
        }
    }

}
```

# TODO
- [ ] Retry call
- [ ] Send request so connect the Internet
- [ ] Create a Unit Tests
- [X] Create a wiki
- [X] Add a repsonse model for send extra information like http status code
- [X] File Upload
- [X] Improve request Syntax
- [X] Error Handler
- [X] Add support for coloring in AppCode

# Third party libraries and references
- Alamofire    https://github.com/Alamofire/Alamofire
- Genome       https://github.com/LoganWright/Genome
- Endpoint     https://github.com/devxoul/Endpoint
- Reachability https://github.com/ashleymills/Reachability.swift
- [SwiftyBeaver](http://swiftybeaver.com/)

# LICENSE
EasyRest is available under the MIT license. See the LICENSE file for more info.
