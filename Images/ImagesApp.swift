//
//  ImagesApp.swift
//  Images
//
//  Created by Ismail on 5.09.2021.
//

import SwiftUI

private func isRunningUnitTests() -> Bool {
    ProcessInfo.processInfo.environment["IS_RUNNING_UNIT_TESTS"] == "1"
}

@main
struct ImagesApp: App {
    var body: some Scene {
        WindowGroup {
            if isRunningUnitTests() {
                ImagesAppView(imageListViewModel: ImageListViewModelForPreview(images: ImageModel.mocks(of: 5)))
            } else {
                ImagesAppView(imageListViewModel: ImageListViewModel())
            }
        }
    }
}
