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
            Task { await viewModel.onButtonTapped() }
        } label: {
            if viewModel.state.isLoading {
                ProgressView()
                    .transition(.opacity)
            } else {
                Text("Open random useful article")
                    .font(.footnote)
                    .fontWeight(.bold)
            }
        }
        .disabled(viewModel.state.isLoading)
        .padding()
        .buttonStyle(.bordered)
        .onChange(of: viewModel.state.url) {
            guard let url = viewModel.state.url else { return }
            openURL(url)
        }
        .alert(isPresented: $viewModel.state.isAlertShown, error: MyUsefulLinksAPIClientError.notFound) {}
    }
}

extension MyUsefulLinksAPIClientError: LocalizedError {
    var errorDescription: String? { "We run out of links" }
    var recoverySuggestion: String? { "There is nothing you can do" }
    var failureReason: String? { "You tapped on the button too much" }
}
