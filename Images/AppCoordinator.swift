//
//  AppCoordinator.swift
//  Images
//
//  Created by Ismail on 24.03.2024.
//

import Combine
import Kingfisher
import SwiftUI

final class AppCoordinator<ImageListVM>: ObservableObject where ImageListVM: ImageListViewModelProtocol {
    @Published var path: NavigationPath = .init()
    private var cancellables = Set<AnyCancellable>()
    private let imageListViewModel: ImageListVM

    private lazy var imageListCoordinator: ImageListCoordinator = {
        let coordinator = ImageListCoordinator(viewModel: imageListViewModel)
        bind(imageListCoordinator: coordinator)
        return coordinator
    }()

    init(imageListViewModel: ImageListVM) {
        self.imageListViewModel = imageListViewModel
        configureKingfisherCache()
    }

    @ViewBuilder
    func build() -> some View {
        imageListCoordinator.build()
    }

    private func configureKingfisherCache() {
        KingfisherManager.shared.cache.memoryStorage.config.totalCostLimit = 20480 // 20 MB
        KingfisherManager.shared.cache.diskStorage.config.sizeLimit = 102_400 // 100 MB
    }

    private func push<T: Hashable>(_ coordinator: T) {
        path.append(coordinator)
    }

    private func bind<T>(imageListCoordinator coordinator: ImageListCoordinator<T>) {
        coordinator.pushCoordinator
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] coordinator in
                self?.push(coordinator)
            })
            .store(in: &cancellables)
    }
}
