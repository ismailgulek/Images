//
//  ImageListCoordinator.swift
//  Images
//
//  Created by Ismail on 24.03.2024.
//

import Combine
import SwiftUI

/// Coordinator for image list view.
final class ImageListCoordinator<ViewModel>: ObservableObject where ViewModel: ImageListViewModelProtocol {
    private let id: UUID
    private let viewModel: ViewModel
    private var cancellables = Set<AnyCancellable>()

    let pushCoordinator = PassthroughSubject<ImageDetailCoordinator, Never>()

    init(viewModel: ViewModel) {
        id = UUID()
        self.viewModel = viewModel
    }

    @ViewBuilder
    func build() -> some View {
        imageListView()
    }

    // MARK: View Creation

    private func imageListView() -> some View {
        // swiftformat:disable:next redundantSelf
        let view = ImageListView(viewModel: self.viewModel)
        bind(view: view)
        return view
    }

    // MARK: View Bindings

    private func bind<V>(view: ImageListView<V>) {
        view.didTapImageRow
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] image in
                self?.showImageDetail(for: image)
            })
            .store(in: &cancellables)
    }
}

// MARK: - Hashable

extension ImageListCoordinator: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: ImageListCoordinator, rhs: ImageListCoordinator) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Navigation

extension ImageListCoordinator {
    private func showImageDetail(for image: ImageModel) {
        pushCoordinator.send(ImageDetailCoordinator(image: image))
    }
}
