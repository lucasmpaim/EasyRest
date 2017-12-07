 ![](https://github.com/lucasmpaim/EasyRest/blob/master/Images/logo.png)
 
 
 [![Build Status](https://www.bitrise.io/app/26434cc1ea3414c5/status.svg?token=DtKIwnE_HhoEyWPnAF6nhw)](https://www.bitrise.io/app/26434cc1ea3414c5)
 ![](https://cocoapod-badges.herokuapp.com/v/EasyRest/badge.png)
 ![](https://cocoapod-badges.herokuapp.com/p/EasyRest/badge.png)
 ![](https://cocoapod-badges.herokuapp.com/l/EasyRest/badge.(png|svg))

# Motivation
After reviewing many REST clients for iOS , we realize that all are very verbose , which is unnecessary.
This library was born from the need to simplify the communication between client and server.

## Requirements
 - Swift 3+

For Swift 2.2 and 2.3 check the branches.

## Documentation
You can read the doc's in this [wiki](https://github.com/lucasmpaim/EasyRest/wiki)

## Usage
To add EasyRest to your project, add the following in your podfile

```Ruby
pod 'EasyRest'
pod 'EasyRest/LoggerBeaver'
```

### Swift 4
If you are using Swift 4 add this to end of your podfile

```
post_install do |installer|
    installer.pods_project.targets.each do |target|
    compatibility_pods = ['Genome']
        if compatibility_pods.include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.2'
            end
        end
    end
end

```

## Model Example:
```swift
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

    case me(String)
    case post(String)

    var rule: Rule {
        switch(self) {
            case let .me(name):
                return Rule(method: .GET, path: "/api/v1/users/me/", isAuthenticable: true, parameters: [.query : ["name": name]])
            case let .post(id):
                let parameters : [ParametersType: AnyObject] = [:]
                return Rule(method: .get, path: "/api/v1/posts/\(id)/", isAuthenticable: true, parameters: parameters)
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
        try! call(.me(name), type: UserTest.self, onSuccess: onSuccess, onError: defaultErrorHandler(onError), always: always)
    }
    
    func post(id: Int, onSuccess: (result: Response<Post>?) -> Void, onError: (ErrorType?) -> Void, always: () -> Void) {
        try! call(.post(id), type: Post.self, onSuccess: onSuccess, onError: defaultErrorHandler(onError), always: always)
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
- [ ] Remove Genome and use a Swift 4 Codable
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
