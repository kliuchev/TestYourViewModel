//
//  MyBadViewModel.swift
//  TestYourViewModel
//
//  Created by Sviatoslav on 29/08/2025.
//

import Foundation
import Combine

final class MyBadViewModelImpl: MyViewModel {
    
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
        state.isLoading = false // oops there is a mistake!
        defer { state.isLoading = false }
        
        do {
            // here is another one
            state.url = URL(string: "https://www.youtube.com/watch?v=dQw4w9WgXcQ")
            state.url = try await apiClient.getRandomUsefulLink()
        } catch {
            state.isAlertShown = true
        }
    }
}


