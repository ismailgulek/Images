//
//  AppCoordinatorTests.swift
//  ImagesTests
//
//  Created by Ismail on 25.03.2024.
//

import Combine
@testable import Images
import XCTest

final class AppCoordinatorTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()

    func testPath() async throws {
        let viewModel = ImageListViewModelForPreview(images: [.mock])
        let coordinator = AppCoordinator(imageListViewModel: viewModel)

        guard let view = coordinator.build() as? ImageListView<ImageListViewModelForPreview> else {
            XCTFail("Couldn't build view")
            return
        }
        // simulate a row tapped
        await view.didTapImageRow.send(.mock)
        try await Task.sleep(for: .milliseconds(300))
        XCTAssertEqual(coordinator.path.count, 1)
    }
}
