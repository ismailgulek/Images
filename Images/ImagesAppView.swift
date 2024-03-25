//
//  ImagesAppView.swift
//  Images
//
//  Created by Ismail on 24.03.2024.
//

import SwiftUI

struct ImagesAppView<ImageListVM>: View where ImageListVM: ImageListViewModelProtocol {
    @ObservedObject private var appCoordinator: AppCoordinator<ImageListVM>

    init(imageListViewModel: ImageListVM) {
        appCoordinator = AppCoordinator(imageListViewModel: imageListViewModel)
    }

    var body: some View {
        NavigationStack(path: $appCoordinator.path) {
            appCoordinator.build()
                .navigationDestination(for: ImageDetailCoordinator.self) { $0.build() }
        }
        .environmentObject(appCoordinator)
    }
}
