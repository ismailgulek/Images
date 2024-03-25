//
//  ImagesAPI.swift
//  Images
//
//  Created by Ismail on 5.09.2021.
//

import Foundation

enum ImagesAPI {
    private enum Constants {
        static let apiBaseURL = URL(string: "https://api.pexels.com/v1/")
        static let apiKey = "I1kf9Uj6VBKLm77P4MsV1hzWb8upcR78vB4hEa27nFAlJxiamNdm8ZZ2"
    }

    /// This endpoint enables you to receive real-time photos curated by the Pexels team. Api path: `curated`.
    ///  - Parameter page: The page number you are requesting. Default: 1
    ///  - Parameter perPage: The number of results you are requesting per page. Default: 15, Max: 80
    case loadCuratedImages(page: Int?, perPage: Int?)

    private var url: URL {
        switch self {
        case let .loadCuratedImages(page, perPage):
            guard let url = URL(string: "curated", relativeTo: Constants.apiBaseURL) else {
                fatalError("Could not build api url")
            }
            guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                fatalError("Could not build url components object")
            }

            urlComponents.queryItems = []
            if let page {
                urlComponents.queryItems?.append(URLQueryItem(name: "page", value: String(page)))
            }
            if let perPage = perPage {
                urlComponents.queryItems?.append(URLQueryItem(name: "per_page", value: String(perPage)))
            }

            guard let url = urlComponents.url else {
                fatalError("Could not build url for loadCuratedImages request")
            }
            return url
        }
    }

    /// Constructs a  URLRequest for the receiver api.
    var urlRequest: URLRequest {
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Constants.apiKey, forHTTPHeaderField: "Authorization")
        request.cachePolicy = .returnCacheDataElseLoad
        return request
    }
}
