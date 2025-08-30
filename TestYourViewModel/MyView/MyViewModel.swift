//
//  MyViewModel.swift
//  TestYourViewModel
//
//  Created by Sviatoslav on 29/08/2025.
//

import Foundation
import Combine

@MainActor
protocol MyViewModel: ObservableObject {
    
    // MARK: - State
    
    var state: MyViewState { get set }
    
    
    // MARK: - Events
    
    func onButtonTapped() async
}


final class MyViewModelImpl: MyViewModel {
    // MARK: - Dependencies
    
    private let apiClient: MyUsefulLinksAPIClient
    
    // MARK: - State
    
    @Published var state: MyViewState
    
    // MARK: - Initializer
    
    init(apiClient: MyUsefulLinksAPIClient) {
        self.apiClient = apiClient
        self.state = .init()
    }
    
    // MARK: - Events
    
    func onButtonTapped() async {
        state.isLoading = true
        defer { state.isLoading = false }
        
        do {
            state.url = try await apiClient.getRandomUsefulLink()
        } catch {
            state.isAlertShown = true
        }
    }
}
