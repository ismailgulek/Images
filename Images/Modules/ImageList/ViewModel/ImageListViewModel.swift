//
//  ImageListViewModel.swift
//  Images
//
//  Created by Ismail on 5.09.2021.
//

import Combine
import SwiftUI

final class ImageListViewModel: ImageListViewModelProtocol {
    private enum Constants {
        static let itemsPerPage: Int = 15 //  max allowed to 80
    }

    @Published private(set) var images: [ImageModel] = []
    @Published private(set) var hasMoreImages = false
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error? = nil
    private let urlSession: URLSession
    private var page: Int = 1
    private var isLoaded = false

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    private var cancellableRequest: Cancellable? {
        didSet { oldValue?.cancel() }
    }

    deinit {
        cancellableRequest?.cancel()
    }

    private func resetPage() {
        page = 1
    }

    private func incrementPage() {
        page += 1
    }

    //  MARK: - Load

    func load() {
        guard !isLoaded else { return }
        resetPage()
        isLoading = true

        let request = ImagesAPI.loadCuratedImages(page: page,
                                                  perPage: Constants.itemsPerPage).urlRequest

        cancellableRequest = urlSession.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: ImageListModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.error = error
                }
            }, receiveValue: { [weak self] response in
                guard let self else { return }
                self.error = nil
                self.images = response.images.distinct()
                self.hasMoreImages = response.totalResults > response.images.count
                self.isLoading = false
                self.isLoaded = true
            })
    }

    func loadNextPage() {
        incrementPage()

        let request = ImagesAPI.loadCuratedImages(page: page,
                                                  perPage: Constants.itemsPerPage).urlRequest

        cancellableRequest = urlSession.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: ImageListModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.error = error
                }
            }, receiveValue: { [weak self] response in
                guard let self else { return }
                self.error = nil
                var all = self.images
                all.append(contentsOf: response.images)
                self.images = all.distinct()
                self.hasMoreImages = response.totalResults > self.images.count
            })
    }

    //  MARK: - Refresh

    func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // there might be some new data, remove cache first
            URLCache.shared.removeAllCachedResponses()
            self.isLoaded = false
            self.load()
        }
    }
}

extension Array where Element: Hashable {
    func distinct() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
