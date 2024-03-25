//
//  ImageListViewModelProtocol.swift
//  Images
//
//  Created by Ismail on 24.03.2024.
//

import Foundation

/// View model for image list view
protocol ImageListViewModelProtocol: ObservableObject {
    /// Image objects currently fetched
    var images: [ImageModel] { get }

    /// There is more images available on the api
    var hasMoreImages: Bool { get }

    /// Flag indicating currently loading some images
    var isLoading: Bool { get }

    /// Will be set when an operation fails. Will be cleared after a successful operation.
    var error: Error? { get }

    /// Load first page
    func load()

    /// Load next page
    func loadNextPage()

    /// Reset and load first page again
    func refresh()
}
