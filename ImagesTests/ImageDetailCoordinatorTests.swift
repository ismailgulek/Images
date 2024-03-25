//
//  ImageDetailCoordinatorTests.swift
//  ImagesTests
//
//  Created by Ismail on 25.03.2024.
//

import Combine
@testable import Images
import XCTest

final class ImageDetailCoordinatorTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()

    func testEquality() {
        let coordinator1 = ImageDetailCoordinator(image: .mock)
        let coordinator2 = ImageDetailCoordinator(image: .mock)
        XCTAssertEqual(coordinator1, coordinator2)
        XCTAssertEqual(coordinator1.hashValue, coordinator2.hashValue)
    }

    func testBuild() {
        let coordinator = ImageDetailCoordinator(image: .mock)
        XCTAssertNotNil(coordinator.build() as? ImageDetailView)
    }
}
