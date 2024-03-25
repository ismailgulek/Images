//
//  ImageListModel.swift
//  Images
//
//  Created by Ismail on 5.09.2021.
//

import Foundation

/// Response model for https://www.pexels.com/api/documentation/#photos-curated
struct ImageListModel: Codable {
    var page: Int
    var perPage: Int
    var images: [ImageModel]
    var totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case images = "photos"
        case totalResults = "total_results"
    }
}

//  MARK: - Mock Data

extension ImageListModel {
    static let empty = ImageListModel(page: 1, perPage: 1, images: [], totalResults: 0)
}
