//
//  ImageDetailViewModel.swift
//  Images
//
//  Created by Ismail on 23.03.2024.
//

import Combine
import Foundation
import SwiftUI

/// View model for image detail view
class ImageDetailViewModel: ObservableObject {
    @Published private(set) var image: ImageModel

    init(image: ImageModel) {
        self.image = image
    }
}
