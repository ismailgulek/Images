//
//  ImageListViewModelForPreviewTests.swift
//  ImagesTests
//
//  Created by Ismail on 24.03.2024.
//

@testable import Images
import XCTest

final class ImageListViewModelForPreviewTests: XCTestCase {
    func testInit() {
        let viewModel = ImageListViewModelForPreview(images: ImageModel.mocks(of: 10),
                                                     hasMoreImages: true,
                                                     isLoading: true,
                                                     error: MockError.generic)
        XCTAssertEqual(viewModel.images, ImageModel.mocks(of: 10))
        XCTAssertEqual(viewModel.hasMoreImages, true)
        XCTAssertEqual(viewModel.isLoading, true)
        XCTAssertEqual(viewModel.error as? MockError, MockError.generic)
    }

    func testMethodsDoNothing() async throws {
        let viewModel = ImageListViewModelForPreview(images: ImageModel.mocks(of: 10),
                                                     hasMoreImages: true,
                                                     isLoading: true,
                                                     error: MockError.generic)

        viewModel.load()
        viewModel.loadNextPage()
        viewModel.refresh()
        try await Task.sleep(for: .milliseconds(100))

        XCTAssertEqual(viewModel.images, ImageModel.mocks(of: 10))
        XCTAssertEqual(viewModel.hasMoreImages, true)
        XCTAssertEqual(viewModel.isLoading, true)
        XCTAssertEqual(viewModel.error as? MockError, MockError.generic)
    }
}
