//
//  ImageListViewModelForPreview.swift
//  Images
//
//  Created by Ismail on 5.09.2021.
//

import Foundation

final class ImageListViewModelForPreview: ImageListViewModelProtocol {
    @Published private(set) var images: [ImageModel]
    @Published private(set) var hasMoreImages: Bool
    @Published private(set) var isLoading: Bool
    @Published private(set) var error: Error?

    init(images: [ImageModel] = [],
         hasMoreImages: Bool = false,
         isLoading: Bool = false,
         error: Error? = nil)
    {
        self.images = images
        self.hasMoreImages = hasMoreImages
        self.isLoading = isLoading
        self.error = error
    }

    func load() {}
    func loadNextPage() {}
    func refresh() {}
}
