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
    
    var isLoading: Bool { get }
    var isAlertShown: Bool { get set }
    var url: URL? { get }
    
    
    // MARK: - Events
    
    func onGetRandomVideoButtonTapped() async
}


final class MyViewModelImpl: MyViewModel {

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
        isLoading = true
        defer { isLoading = false }
        
        do {
            url = try await apiClient.getRandomUsefulLink()
        } catch {
            isAlertShown = true
        }
    }
}
