//
//  ImageListViewModelTests.swift
//  ImagesTests
//
//  Created by Ismail on 24.03.2024.
//

@testable import Images
import XCTest

final class ImageListViewModelTests: XCTestCase {
    func testError() async throws {
        MockURLProtocol.error = MockError.generic
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 500,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            return (response, nil)
        }
        let viewModel = ImageListViewModel(urlSession: .mock)
        viewModel.load()
        try await Task.sleep(for: .milliseconds(100))
        XCTAssertNotNil(viewModel.error)
    }

    func testLoadPagesAndRefresh() async throws {
        // load first page
        MockURLProtocol.error = nil
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!

            let result = ImageListModel(page: 1,
                                        perPage: 15,
                                        images: ImageModel.mocks(of: 15),
                                        totalResults: 30)
            let data = try JSONEncoder().encode(result)

            return (response, data)
        }

        let viewModel = ImageListViewModel(urlSession: .mock)
        viewModel.load()
        XCTAssertTrue(viewModel.isLoading)
        try await Task.sleep(for: .milliseconds(100))
        XCTAssertNil(viewModel.error)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.images.count, 15)
        XCTAssertTrue(viewModel.hasMoreImages)

        // load next page
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!

            let result = ImageListModel(page: 2,
                                        perPage: 15,
                                        images: ImageModel.mocks(of: 15, starting: 16),
                                        totalResults: 30)
            let data = try JSONEncoder().encode(result)

            return (response, data)
        }
        viewModel.loadNextPage()
        try await Task.sleep(for: .milliseconds(100))
        XCTAssertNil(viewModel.error)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.images.count, 30)
        XCTAssertFalse(viewModel.hasMoreImages)

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!

            let result = ImageListModel(page: 1,
                                        perPage: 15,
                                        images: ImageModel.mocks(of: 15),
                                        totalResults: 30)
            let data = try JSONEncoder().encode(result)

            return (response, data)
        }
        viewModel.refresh()
        try await Task.sleep(for: .milliseconds(1100))
        XCTAssertNil(viewModel.error)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.images.count, 15)
        XCTAssertTrue(viewModel.hasMoreImages)
    }
}
