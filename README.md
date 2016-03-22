# Motivation
After reviewing many REST clients for iOS , we realize that all are very verbose , which is unnecessary.
This library was born from the need to simplify the communication between client and server.

## Requirements
 - Swift 2.2
 - XCode 7.3
 - XCode Color Plugin: https://github.com/robbiehanson/XcodeColors

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
```

## Route Example:
```swift

enum TestRoute: Routable{

    case Me

    typealias authenticatorClass = OAuth2Service

    var base: String { return "http://www.xpto.com" }

    var rule: Rule {
        switch(self) {
            case let .Me(name):
                return Rule(method: .GET, path: "/api/v1/users/me/", isAuthenticable: true, parameters: [.Query : ["name": name]])
            }
    }

    var authenticable: Bool {
        switch(self) {
            case .Me: return true
        }
    }

    func authenticator () -> authenticatorClass? {
        return oauth2Service
    }

}

```

## Call Example:
```swift
oauth2Service.interceptors = [DefaultHeadersInterceptor()]

oauth2Service.loginWithPassword("abcd@abcd.com", password: "abcd@1234", onSucess: {

        try! TestRoute.Me.builder(UserTest.self).build().execute({ (result) -> Void in

        }, onError: { (error) -> Void in

        }, always: { () -> Void in

        })


    }, onError: {error in
    }, always: {
})
```
## Interceptor Example:

```swift
class CurlInterceptor: Interceptor {

    required init() {}

    func requestInterceptor<T: MappableBase>(api: API<T>) {}

    func responseInterceptor<T: MappableBase>(api: API<T>, response: Alamofire.Response<AnyObject, NSError>) {
        if Utils.isSucessRequest(response) {
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
- [ ] Use PureJSon serializer in request
- [ ] Improve request Syntax


# Third party libraries and references
- Genome       https://github.com/LoganWright/Genome
- Endpoint     https://github.com/devxoul/Endpoint
- Reachability https://github.com/ashleymills/Reachability.swift

# LICENSE
EasyRest is available under the MIT license. See the LICENSE file for more info.
