//
//  ImageDetailView.swift
//  Images
//
//  Created by Ismail on 23.03.2024.
//

import Kingfisher
import SwiftUI

struct ImageDetailView: View {
    @ObservedObject var viewModel: ImageDetailViewModel
    @State private var displayError = false
    @State private var displayInfo = false

    init(viewModel: ImageDetailViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            KFImage.url(viewModel.image.source.originalURL)
                .lowDataModeSource(.network(viewModel.image.source.thumbnailURL))
                .loadDiskFileSynchronously(false)
                .placeholder { _ in
                    ProgressView()
                }
                .onFailure { _ in
                    displayError = true
                }
                .onSuccess { _ in
                    displayInfo = true
                }
                .resizable()
                .scaledToFit()
            if displayInfo {
                Text(viewModel.image.altText)
                    .padding(.horizontal, 8)
                Link(viewModel.image.photographerName, destination: viewModel.image.photographerURL)
                    .padding(.horizontal, 8)
            }
        }
        .alert("Error", isPresented: $displayError, actions: {}, message: {
            Text("Couldn't fetch the image. Try again later.")
        })
    }
}

struct ImageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ImageDetailView(viewModel: ImageDetailViewModel(image: .mock))
    }
}
