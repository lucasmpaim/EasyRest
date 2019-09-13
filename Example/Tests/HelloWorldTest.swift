import XCTest

import Alamofire
import EasyRest
import PromiseKit

class HelloWorldTest: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSuccessCallback() {
        let expectation = self.expectation(description: "API")
        
        let service = JsonPlaceholderService()
        let _ = try! service.call(
            .post(id: 1),
            type: PostModel.self,
            onSuccess: { result in
                print("RESPONSE ITEM ID: \(result!.body!.id!)")
                expectation.fulfill()
            }, onError: { error in
                print("Error : \(error!.localizedDescription)")
            }, always: {
                print("This code will be called all the time")
            })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testErrorCallback() {
        let expectation = self.expectation(description: "API")
        
        let service = JsonPlaceholderService()
        let _ = try! service.call(
            .post(id: -11),
            type: PostModel.self,
            onSuccess: { result in
                print("RESPONSE ITEM ID: \(result!.body!.id!)")
            }, onError: { error in
                print("Error : \(error!.localizedDescription)")
                expectation.fulfill()
            }, always: {
                print("This code will be called all the time")
            })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSuccessPromise() {
        let expectation = self.expectation(description: "API")
        
        let service = JsonPlaceholderService()
        try! service.call(.post(id: 1), type: PostModel.self).promise
            .done { result in
                print("RESPONSE ITEM ID: \(result!.body!.id!)")
                expectation.fulfill()
            }.catch { error in
                print("Error : \(error.localizedDescription)")
            }.finally {
                print("This code will be called all the time")
            }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testErrorPromise() {
        let expectation = self.expectation(description: "API")
        
        let service = JsonPlaceholderService()
        try! service.call(.post(id: -1), type: PostModel.self).promise
            .done { result in
                print("RESPONSE ITEM ID: \(result!.body!.id!)")
            }.catch { error in
                print("Error : \(error.localizedDescription)")
                expectation.fulfill()
            }.finally {
                print("This code will be called all the time")
            }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testMultipleDesserialization() {
        let expectation = self.expectation(description: "API")
        
        let service = JsonPlaceholderService()
        try! service.call(.posts, type: [PostModel].self).promise
            .done { result in
                print("RESPONSE ITEMS: \(result!.body!)")
                expectation.fulfill()
            }.catch { error in
                print("Error : \(error.localizedDescription)")
            }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testMakePost() {
        let expectation = self.expectation(description: "API")

        let service = JsonPlaceholderService()
        let dto = PostModel()
        dto.body = "body"
        dto.id = 101
        dto.title = "Título"
        dto.userId = 42

        try! service.call(.makePost(body: dto), type: PostModel.self).promise
            .done { result in
                print("RESPONSE ITEM: \(result!.body!)")
                expectation.fulfill()
            }.catch { error in
                print("Error : \(error.localizedDescription)")
            }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testEditPost() {
        let expectation = self.expectation(description: "API")

        let service = JsonPlaceholderService()
        let dto = PostModel()
        dto.body = "body"
        dto.id = 1
        dto.title = "Título"
        dto.userId = 42

        try! service.call(.editPost(id: dto.id!, body: dto), type: PostModel.self).promise
            .done { result in
                print("RESPONSE ITEM: \(result!.body!)")
                expectation.fulfill()
            }.catch { error in
                print("Error : \(error.localizedDescription)")
            }

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testEditTitle() {
        let expectation = self.expectation(description: "API")
        
        let service = JsonPlaceholderService()
        let dto = PostModel()
        dto.title = "Título"
        
        try! service.call(.editTitle(id: 1, body: dto), type: PostModel.self).promise
            .done { result in
                print("RESPONSE ITEM: \(result!.body!)")
                expectation.fulfill()
            }.catch { error in
                print("Error : \(error.localizedDescription)")
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testDeletePost() {
        let expectation = self.expectation(description: "API")

        let service = JsonPlaceholderService()
        try! service.call(.deletePost(id: 1), type: PostModel.self).promise
            .done { result in
                print("Success")
                expectation.fulfill()
            }.catch { error in
                print("Error : \(error.localizedDescription)")
            }

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFilter() {
        let expectation = self.expectation(description: "API")
        
        let service = JsonPlaceholderService()
        try! service.call(.postsFilter(userId: 1), type: [PostModel].self).promise
            .done { result in
                print("RESPONSE ITEMS: \(result!.body!)")
                expectation.fulfill()
            }.catch { error in
                print("Error : \(error.localizedDescription)")
            }.finally {
                print("This code will be called all the time")
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
