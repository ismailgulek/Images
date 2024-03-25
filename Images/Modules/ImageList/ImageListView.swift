//
//  ImageListView.swift
//  Images
//
//  Created by Ismail on 5.09.2021.
//

import Combine
import SwiftUI

struct ImageListView<ViewModel>: View where ViewModel: ImageListViewModelProtocol {
    @StateObject var viewModel: ViewModel

    var isShowingError: Binding<Bool> {
        Binding {
            viewModel.error != nil
        } set: { _ in
        }
    }

    let didTapImageRow = PassthroughSubject<ImageModel, Never>()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    //  show placeholder rows
                    List {
                        ForEach(0 ..< 12) { _ in
                            ImageRowView(image: .mock)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .redacted(reason: .placeholder)
                } else if viewModel.images.isEmpty {
                    //  show no images view
                    VStack {
                        Image(systemName: "nosign")
                            .font(Font.title2.bold())
                            .frame(width: 44, height: 44, alignment: .center)
                        Text("No images found")
                            .font(Font.body)
                    }
                } else {
                    //  real list
                    List {
                        ForEach(viewModel.images) { image in
                            ImageRowView(image: image)
                                .onTapGesture {
                                    didTapImageRow.send(image)
                                }
                                .id(image.id)
                                .listRowSeparator(.hidden)
                        }
                        if viewModel.hasMoreImages {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                            .onAppear(perform: {
                                viewModel.loadNextPage()
                            })
                        } else {
                            Text("\(viewModel.images.count) images")
                                .font(Font.caption)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .refreshable {
                        viewModel.refresh()
                    }
                }
            }
            .navigationBarTitle(Text("Images"))
            .alert("Error", isPresented: isShowingError, actions: {}, message: {
                Text("Couldn't fetch images. Try again later.")
            })
            .onAppear(perform: {
                viewModel.load()
            })
        }
    }
}

struct ImageListView_Previews_Filled: PreviewProvider {
    static var previews: some View {
        ImageListView(viewModel: ImageListViewModelForPreview(images: ImageModel.mocks(of: 3)))
    }
}

struct ImageListView_Previews_Filled_HasMore: PreviewProvider {
    static var previews: some View {
        ImageListView(viewModel: ImageListViewModelForPreview(images: ImageModel.mocks(of: 3), hasMoreImages: true))
    }
}

struct ImageListView_Previews_Empty: PreviewProvider {
    static var previews: some View {
        ImageListView(viewModel: ImageListViewModelForPreview(images: []))
    }
}
