//
//  MyView.swift
//  TestYourViewModel
//
//  Created by Sviatoslav on 29/08/2025.
//

import SwiftUI

struct MyView<VM: MyViewModel>: View {
    
    @ObservedObject var viewModel: VM
    @Environment(\.openURL) var openURL
    
    var body: some View {
        Button {
            Task { await viewModel.onGetRandomVideoButtonTapped() }
        } label: {
            if viewModel.isLoading {
                ProgressView()
                    .transition(.opacity)
            } else {
                Text("Open random useful article")
                    .font(.footnote)
                    .fontWeight(.bold)
            }
        }
        .disabled(viewModel.isLoading)
        .padding()
        .buttonStyle(.bordered)
        .onChange(of: viewModel.url) {
            guard let url = viewModel.url else { return }
            openURL.callAsFunction(url)
        }
        .alert(isPresented: $viewModel.isAlertShown, error: MyUsefulLinksAPIClientError.notFound) {}
    }
}

extension MyUsefulLinksAPIClientError: LocalizedError {
    var errorDescription: String? { "We run out of links" }
    var recoverySuggestion: String? { "There is nothing you can do" }
    var failureReason: String? { "You tapped on the button too much" }
}
