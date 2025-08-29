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
    
    @Published var isLoading: Bool = false
    @Published var isAlertShown: Bool = false
    @Published var url: URL?
    
    // MARK: - Initializer
    
    init(apiClient: MyUsefulLinksAPIClient) {
        self.apiClient = apiClient
    }
    
    // MARK: - Events
    
    func onGetRandomVideoButtonTapped() async {
        isLoading = false // oops there is a mistake!
        defer { isLoading = false }
        
        do {
            url = URL(string: "https://www.youtube.com/watch?v=dQw4w9WgXcQ")
            url = try await apiClient.getRandomUsefulLink()
        } catch {
            isAlertShown = true
        }
    }
}
