 ![](https://github.com/lucasmpaim/EasyRest/blob/master/Images/logo.png)
 
 
 [![Build Status](https://www.bitrise.io/app/26434cc1ea3414c5/status.svg?token=DtKIwnE_HhoEyWPnAF6nhw)](https://www.bitrise.io/app/26434cc1ea3414c5)
 ![](https://cocoapod-badges.herokuapp.com/v/EasyRest/badge.png)
 ![](https://cocoapod-badges.herokuapp.com/p/EasyRest/badge.png)
 ![](https://cocoapod-badges.herokuapp.com/l/EasyRest/badge.(png|svg))

# Motivation
After reviewing many REST clients for iOS , we realize that all are very verbose , which is unnecessary.
This library was born from the need to simplify the communication between client and server.

## Requirements
 - Swift 4+

For Swift 2.2, 2.3 and 3 check the branches.

## Documentation
You can read the doc's in this [wiki](https://github.com/lucasmpaim/EasyRest/wiki)

## Usage
To add EasyRest to your project, add the following in your podfile

```Ruby
pod 'EasyRest'
pod 'EasyRest/PromiseKit'
```


## Model Example:
```swift
class Post : Codable {

    var id: String?
    var title: String?
    
}
```

## Route Examples:

```swift

// Maps API calls and infos, like method and query params
enum JsonPlaceholderRoutable: Routable {
    // Each API interaction is a case
    case posts
    // Using query params
    case postsFilter(userId: Int)
    // Example with path
    case post(id: Int)
    case deletePost(id: Int)
    // Example with body
    case makePost(body: PostModel)
    // Example with path, body and header
    case editPost(id: Int, body: PostModel)
    case editTitle(id: Int, body: PostModel)
    
    // Now test every possibility in a fashion Swift syntax
    var rule: Rule {
        switch(self) {
        case .posts:
            return Rule(
                method: .get, // HTTP verb
                path: "/posts/", // Endpoint
                isAuthenticable: false, // Uses EasyRest Authenticated Service?
                parameters: [:]) // query/path/header params? Header Body? Multipart form data? Put here!
        case let .postsFilter(userId):
            return Rule(
                method: .get,
                path: "/posts/",
                isAuthenticable: false,
                parameters: [.query: ["userId": "\(userId)"]])
        case let .post(id):
            return Rule(
                method: .get,
                path: "/posts/{id}/",
                isAuthenticable: false,
                parameters: [.path: ["id": id]])
        case let .deletePost(id):
            return Rule(
                method: .delete,
                path: "/posts/{id}/",
                isAuthenticable: false,
                parameters: [.path: ["id": id]])
        case let .makePost(body):
            return Rule(
                method: .post,
                path: "/posts/",
                isAuthenticable: false,
                parameters: [.body: body])
        case let .editPost(id, body):
            return Rule(
                method: .put,
                path: "/posts/{id}",
                isAuthenticable: false,
                parameters: [
                    .path: ["id": id],
                    .body: body,
                    .header: ["Content-type": "application/json; charset=UTF-8"]])
        case let .editTitle(id, body):
            return Rule(
                method: .patch,
                path: "/posts/{id}",
                isAuthenticable: false,
                parameters: [
                    .path: ["id": id],
                    .body: body,
                    .header: ["Content-type": "application/json; charset=UTF-8"]])
        }
    }
}
```

```swift

enum TestRoute: Routable{

    case me(String)
    case post(String)

    var rule: Rule {
        switch(self) {
            case let .me(name):
                return Rule(method: .get, path: "/api/v1/users/me/", isAuthenticable: true, parameters: [.query : ["name": name]])
            case let .post(id):
                let parameters : [ParametersType: AnyObject] = [:]
                return Rule(method: .get, path: "/api/v1/posts/\(id)/",   isAuthenticable: true, parameters: parameters)
            }
    }

}

```

## Service Examples
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

We also suport PromiseKit calls:

```swift
class JsonPlaceholderService : Service<JsonPlaceholderRoutable> {
    override public var base: String { return "https://jsonplaceholder.typicode.com" }
}
```

And then:

```swift
let service = JsonPlaceholderService()
try! service.call(.post(id: 1), type: PostModel.self).promise
    .done { result in
        print("RESPONSE ITEM ID: \(result!.body!.id!)")
    }.catch { error in
        print("Error : \(error.localizedDescription)")
    }.finally {
        print("This code will be called all the time")
    }
```

## Interceptor Example:

```swift
class DefaultHeadersInterceptor : Interceptor {
    required init() {}

    func requestInterceptor<T: Codable>(_ api: API<T>) {
        api.headers["Content-Type"] = "application/json"
        api.headers["Accept"] = "application/json"
        api.headers["Device-Token"] = "8ec3bba7de23cda5e8a2726c081be79204faede67529e617b625c984d61cf5c1"
        api.headers["Device-Agent"] = "iOS_SANDBOX"
        api.headers["Accept-Language"] = "pt-br"
    }

    func responseInterceptor<T: Codable, U>(_ api: API<T>, response: DataResponse<U>) {

    }
}
```

# TODO
- [X] Remove Genome and use a Swift 4 Codable
- [ ] Retry call
- [ ] Send request so connect the Internet
- [X] Create Unit Tests for main functionalities
- [ ] Create Unit Tests for authenticable services
- [ ] Create Unit Tests for multpart-data uploads
- [X] Cancel request
- [X] Create a wiki
- [X] Add a repsonse model for send extra information like http status code
- [X] File Upload
- [X] Improve request Syntax
- [X] Error Handler
- [X] Add support for coloring in AppCode
- [X] Download files in memory
- [X] Download files directily to storage (memory optimal)

# Third party libraries and references
- [Alamofire](https://github.com/Alamofire/Alamofire)
- [Endpoint](https://github.com/devxoul/Endpoint)
- [Reachability](https://github.com/ashleymills/Reachability.swift)
- [PromiseKit](https://github.com/mxcl/PromiseKit)

# LICENSE
EasyRest is available under the MIT license. See the LICENSE file for more info.
