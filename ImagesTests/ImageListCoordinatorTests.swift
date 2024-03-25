//
//  ImageListCoordinatorTests.swift
//  ImagesTests
//
//  Created by Ismail on 25.03.2024.
//

import Combine
@testable import Images
import XCTest

final class ImageListCoordinatorTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()

    func testEquality() {
        let viewModel = ImageListViewModel(urlSession: .mock)
        let coordinator1 = ImageListCoordinator(viewModel: viewModel)
        let coordinator2 = ImageListCoordinator(viewModel: viewModel)
        XCTAssertNotEqual(coordinator1, coordinator2)
        XCTAssertNotEqual(coordinator1.hashValue, coordinator2.hashValue)
    }

    func testPush() async throws {
        let viewModel = ImageListViewModelForPreview(images: [.mock])
        let coordinator = ImageListCoordinator(viewModel: viewModel)
        guard let view = coordinator.build() as? ImageListView<ImageListViewModelForPreview> else {
            XCTFail("Couldn't build view")
            return
        }
        // simulate row tapped
        let pushCalled = expectation(description: "push called")
        await view.didTapImageRow.send(.mock)
        coordinator.pushCoordinator
            .sink { detailCoordinator in
                pushCalled.fulfill()
                XCTAssertEqual(detailCoordinator.image, .mock)
            }
            .store(in: &cancellables)
        wait(for: [pushCalled], timeout: 1)
    }
}
