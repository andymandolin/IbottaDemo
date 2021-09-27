//
//  IbottaDemoTests.swift
//  IbottaDemoTests
//
//  Created by Andrew Geipel on 9/22/21.
//

import XCTest
@testable import IbottaDemo

class IbottaDemoTests: XCTestCase {
    
    var dataManager: DataManager!
      
      override func setUp() {
          super.setUp()

        dataManager = DataManager.sharedInstance
      }
    
    // MARK: - Test cases
      func test_init_DataManager(){
        
        let instance = DataManager.sharedInstance
        XCTAssertNotNil( instance )
      }
    
    func test_fetch_all_products() {

        let results = dataManager.fetchAllOffers()
        // Assert that the total number of products is the same each time
        XCTAssertEqual(results.count, 133)
    }
    
    func test_create_product() {
        
        let id = "000"
        let url = "www.mandolindevelopment.com"
        let name = "Donuts"
        let descript = "Some donuts"
        let terms = "Terms"
        let currentValue = "current value"
        let isFavorite = false
        
        let someProduct: () = dataManager.createProduct(id: id, url: url, name: name, descript: descript, terms: terms, currentValue: currentValue, isFavorite: isFavorite)

        XCTAssertNotNil(someProduct)
    }
    
    func test_remove_person() {
        
        let items = dataManager.fetchAllOffers()
        let offer = items[0]
        
        let numberOfItems = items.count
        
        dataManager.delete(object: offer)
        XCTAssertEqual(dataManager.fetchAllOffers().count, numberOfItems-1)
    }
    
    func test_update_favorites(){
        
        let items = dataManager.fetchAllOffers()
        
        let offer = items[0]
        let isFavorite = offer.isFavorite
        
        DataManager.sharedInstance.updateFavorite(product: offer)
        
        let itemsFetched = dataManager.fetchAllOffers()
        let offerFetched = itemsFetched[0]

        XCTAssertEqual(isFavorite, !offerFetched.isFavorite)
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
