//
//  ImageRowView.swift
//  Images
//
//  Created by Ismail on 5.09.2021.
//

import Kingfisher
import SwiftUI

struct ImageRowView: View {
    @State var image: ImageModel

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            KFImage.url(image.source.thumbnailURL)
                .loadDiskFileSynchronously(false)
                .placeholder { _ in
                    ProgressView()
                }
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text(self.image.photographerName)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .lineLimit(2)
                .foregroundColor(.white)
                .background {
                    Color.black.opacity(0.6)
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(4)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: .primary, radius: 3, x: 0, y: 0)
        .contentShape(Rectangle())
        .listRowInsets(EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8))
    }
}

struct ImageRowView_Previews: PreviewProvider {
    static var previews: some View {
        ImageRowView(image: .mock)
            .previewLayout(.sizeThatFits)
    }
}
