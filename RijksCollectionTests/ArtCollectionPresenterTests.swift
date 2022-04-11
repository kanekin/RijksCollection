//
//  RijksCollectionTests.swift
//  RijksCollectionTests
//
//  Created by Tatsuya Kaneko on 05/04/2022.
//

import XCTest
@testable import RijksCollection

class ArtCollectionPresenterTests: XCTestCase {

    static let mockArtObject1: Model.Collection.ArtObject = .init(
        id: "artObject1",
        objectNumber: "artObject1",
        title: "artObject1",
        hasImage: false,
        webImage: nil,
        principalOrFirstMaker: nil
    )
    
    static let mockArtObject2: Model.Collection.ArtObject = .init(
        id: "artObject2",
        objectNumber: "artObject2",
        title: "artObject2",
        hasImage: false,
        webImage: nil,
        principalOrFirstMaker: nil
    )
    
    func testLoad_artObjectsIsSetInView() async throws {
        // Arrange
        let presenter = ArtCollectionPresenter(
            loader: MockArtCollectionLoader(
                onGetCollection: { _ in
                    return .init(
                        count: 1,
                        artObjects: [
                            ArtCollectionPresenterTests.mockArtObject1
                        ]
                    )
                }
            ),
            router: MockArtCollectionRouter()
        )
        let mockView: MockArtCollectionView = .init()
        presenter.attachView(mockView)
        
        // Act
        await presenter.load(resetPageCount: true)
        
        // Assert
        let newArtObjectsInView = mockView.newArtObjects
        XCTAssertEqual(newArtObjectsInView, [ArtCollectionPresenterTests.mockArtObject1])
    }

    func testLoad_pageCountIsIncremented() async throws {
        // Arrange
        let presenter = ArtCollectionPresenter(
            loader: MockArtCollectionLoader(
                onGetCollection: { _ in
                    return .init(
                        count: 1,
                        artObjects: []
                    )
                }
            ),
            router: MockArtCollectionRouter()
        )
        
        // Act
        await presenter.load(resetPageCount: true)
        
        // Assert
        let lastPageLoaded = await presenter.lastPageLoaded
        XCTAssertEqual(lastPageLoaded, 1)
    }

    func testLoad_callLoadTwice_pageCountIncrementedTwice() async throws {
        // Arrange
        let presenter = ArtCollectionPresenter(
            loader: MockArtCollectionLoader(
                onGetCollection: { _ in
                    return .init(
                        count: 1,
                        artObjects: []
                    )
                }
            ),
            router: MockArtCollectionRouter()
        )
        
        // Act
        await presenter.load(resetPageCount: true)
        await presenter.load()
        
        // Assert
        let lastPageLoaded = await presenter.lastPageLoaded
        XCTAssertEqual(lastPageLoaded, 2)
    }
    
    func testLoad_noInternet_errorMessageIsSet() async throws {
        // Assert
        let presenter = ArtCollectionPresenter(
            loader: MockArtCollectionLoader(
                onGetCollection: { _ in
                    throw NetworkError.noInternet
                }
            ),
            router: MockArtCollectionRouter()
        )
        let mockView: MockArtCollectionView = .init()
        presenter.attachView(mockView)
        
        // Act
        await presenter.load(resetPageCount: true)
        
        // Assert
        let errorMessage = mockView.errorMessage
        XCTAssertEqual(errorMessage, "No Internet. Try again later.")
    }
    
    func testDisplayDetailsPage_routerGetsRightObjectNumber() async throws {
        // Assert
        let router = MockArtCollectionRouter()
        let presenter = ArtCollectionPresenter(
            loader: MockArtCollectionLoader(
                onGetCollection: { _ in
                    return .init(count: 1, artObjects: [])
                }
            ),
            router: router
        )
        
        // Act
        let expectedObjectNumber = "objectNumber"
        await presenter.displayDetailsPage(objectNumber: expectedObjectNumber)
        
        
        // Assert
        let objectNumber = router.objectNumber
        XCTAssertEqual(objectNumber, expectedObjectNumber)
    }
}

class MockArtCollectionLoader: ArtCollectionLoading {
    typealias OnGetCollection = (Int) async throws -> Model.Collection
    
    let onGetCollection: OnGetCollection
    
    init(onGetCollection: @escaping OnGetCollection) {
        self.onGetCollection = onGetCollection
    }
    
    func getCollection(page: Int) async throws -> Model.Collection {
        return try await onGetCollection(page)
    }
}

class MockArtCollectionRouter: ArtCollectionRouting {
    var objectNumber: String?
    
    func displayDetailsPage(objectNumber: String) {
        self.objectNumber = objectNumber
    }
}

class MockArtCollectionView: ArtCollectionView {
    var errorMessage: String?
    var newArtObjects: [Model.Collection.ArtObject]?
    
    func displayErrorMessage(_ message: String?) {
        errorMessage = message
    }
    
    func updateView(_ newArtObjects: [Model.Collection.ArtObject]) {
        self.newArtObjects = newArtObjects
    }
}
