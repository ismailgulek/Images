//
//  ImageModel.swift
//  Images
//
//  Created by Ismail on 5.09.2021.
//

import Foundation

/// Response model for https://www.pexels.com/api/documentation/#photos-overview
struct ImageModel: Identifiable, Codable {
    struct Source: Codable {
        var originalURL: URL
        var thumbnailURL: URL

        enum CodingKeys: String, CodingKey {
            case originalURL = "original"
            case thumbnailURL = "medium"
        }
    }

    var id: Int
    var photographerName: String
    var photographerURL: URL
    var altText: String
    var source: Source

    enum CodingKeys: String, CodingKey {
        case id
        case photographerName = "photographer"
        case photographerURL = "photographer_url"
        case altText = "alt"
        case source = "src"
    }
}

extension ImageModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: ImageModel, rhs: ImageModel) -> Bool {
        lhs.id == rhs.id
    }
}

//  MARK: - Mock Data

extension ImageModel.Source {
    static let mock = Self(originalURL: Bundle.main.url(forResource: "mockOriginal", withExtension: "jpg")!,
                           thumbnailURL: Bundle.main.url(forResource: "mockThumbnail", withExtension: "jpg")!)
}

extension ImageModel {
    // swiftformat:disable:next numberFormatting
    static let mock = Self(id: 2014422,
                           photographerName: "Joey Farina",
                           photographerURL: URL(string: "https://www.pexels.com/@joey")!,
                           altText: "Brown Rocks During Golden Hour",
                           source: .mock)

    private static func mock(withID id: Int) -> Self {
        var result = mock
        result.id = id
        return result
    }

    /// Geerates unique number of mock objects
    /// - Parameters:
    ///   - number: Number of objecys to generate
    ///   - from: ID of the first mock object. Defaults to `1`
    /// - Returns: Unique mock objects
    static func mocks(of number: Int, starting from: Int = 1) -> [Self] {
        (from ..< from + number).map { mock(withID: $0) }
    }
}
