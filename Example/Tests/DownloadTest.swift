import XCTest

class DownloadTest: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDownloadLogo() {
        let expectation = self.expectation(description: "Download")
        
        let service = DownloadUrlService()
        try! service.download(.logo, onProgress: {p in
            print("Progress: \(p)")
        }).promise
            .done { result in
                expectation.fulfill()
            }.catch { error in
                print("Error : \(error.localizedDescription)")
            }.finally {
                print("This code will be called all the time")
            }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
