//
//  ImageDetailCoordinator.swift
//  Images
//
//  Created by Ismail on 24.03.2024.
//

import Combine
import SwiftUI

/// Coordinator for image detail view.
final class ImageDetailCoordinator {
    let image: ImageModel

    init(image: ImageModel) {
        self.image = image
    }

    @ViewBuilder
    func build() -> some View {
        imageDetailView()
    }

    // MARK: View Creation Methods

    private func imageDetailView() -> some View {
        let viewModel = ImageDetailViewModel(image: image)
        return ImageDetailView(viewModel: viewModel)
    }
}

// MARK: - Hashable

extension ImageDetailCoordinator: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(image.id)
    }

    static func == (lhs: ImageDetailCoordinator, rhs: ImageDetailCoordinator) -> Bool {
        return lhs.image.id == rhs.image.id
    }
}
