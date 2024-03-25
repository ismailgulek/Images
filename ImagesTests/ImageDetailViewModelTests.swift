//
//  ImageDetailViewModelTests.swift
//  ImagesTests
//
//  Created by Ismail on 24.03.2024.
//

@testable import Images
import XCTest

final class ImageDetailViewModelTests: XCTestCase {
    func testInit() {
        let viewModel = ImageDetailViewModel(image: .mock)
        XCTAssertEqual(viewModel.image, .mock)
    }
}
