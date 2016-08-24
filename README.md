# Warning
This project is still under development. Feedback and suggestions are very welcome and I encourage you to use the Issues list on Github to provide that feedback.
Feel free to fork this repo and to commit your additions.

For production use it at your own risk.

# Motivation
After reviewing many REST clients for iOS , we realize that all are very verbose , which is unnecessary.
This library was born from the need to simplify the communication between client and server.

## Requirements
 - Swift 2.2
 
### For XCode
 - XCode 7.3
 - XCode Color Plugin: https://github.com/robbiehanson/XcodeColors

### For AppCode
 - Grep Console
 - Enable ANSI colors in Grep Console
 - Add the following to your AppDelegate
 
 ```swift
 Logger.isAppCode = true
 ```
 
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

    case Me
    case Post

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
    
    func me(name: String, onSuccess: (result: UserTest?) -> Void, onError: (ErrorType?) -> Void, always: () -> Void) {
        try! call(.Me(name), type: UserTest.self, onSuccess: onSuccess, onError: defaultErrorHandler(onError), always: always)
    }
    
    func post(id: Int, onSuccess: (result: Post?) -> Void, onError: (ErrorType?) -> Void, always: () -> Void) {
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

## Service Call Example:
```swift

let service = TestRouteService()

let postID = 23
service.post(postID, { (result) in
                print(result?.title)
            }, onError: { (error) in
                
            }, always: {
            
        })
 // OR
 try! service.call(.Post(postID), type: Post.self, onSuccess: { (result) in
                print(result?.title)
            }, onError: { (error) in
                
            }, always: {
            
        })
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
## Authentication (OAuth, etc):
```swift
// Under development
```

## Using without creating a Service:
```swift
let oauth2Authenticator = OAuth2Authenticator()
let BASE_URL = "http://jsonplaceholder.typicode.com"
let postID = 23

try! TestRoute.Post(postID).builder(BASE_URL, type: Post.self, authInterceptor: oauth2Authenticator)
      .addInterceptor(DefaultHeadersInterceptor())
      .build().execute({ (result) in
               print(result?.title)
            }, onError: { (error) in
                
            }, always: {
        })
```

# TODO
- [ ] Retry call
- [ ] Send request so connect the Internet
- [ ] Use PureJSon serializer in request
- [X] Improve request Syntax
- [X] Error Handler
- [X] Add support for coloring in AppCode

# Third party libraries and references
- Alamofire    https://github.com/Alamofire/Alamofire
- Genome       https://github.com/LoganWright/Genome
- Endpoint     https://github.com/devxoul/Endpoint
- Reachability https://github.com/ashleymills/Reachability.swift

# LICENSE
EasyRest is available under the MIT license. See the LICENSE file for more info.
