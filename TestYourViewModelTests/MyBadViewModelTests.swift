//
//  MyBadViewModelTests.swift
//  TestYourViewModel
//
//  Created by Sviatoslav on 29/08/2025.
//

import Foundation
import Testing
import PublisherRecorder

@testable import TestYourViewModel

@MainActor
struct MyBadViewModelTests {

    // MARK: - Good tests that cover state changes
    
    @Test func expectedToShowAlertAndLoadingState_whenAPIClientThrowsError() async throws {
        let apiClient = MockAPIClient {
            throw MyUsefulLinksAPIClientError.notFound
        }
        
        let sut = makeSUT(apiClient: apiClient)
        
        let state = sut.$state.record()
        
        // trigger
        await sut.onButtonTapped()
        
        #expect(apiClient.getRandomUsefulLinkIsCalled)
        
        
        let expectedStates = [
            MyViewState.init(isLoading: false),
            MyViewState.init(isLoading: true),
            MyViewState.init(isLoading: true, isAlertShown: true),
            MyViewState.init(isLoading: false, isAlertShown: true)
        ]
        
        #expect(state.output == expectedStates)
    }
    
    @Test func expectedToOpenURLAndShowLoadingState_whenAPIClientReturnsURL() async throws  {
        let expectedURL = URL(string: "https://google.com")!
        let apiClient = MockAPIClient { expectedURL }
        
        let sut = makeSUT(apiClient: apiClient)
        
        let state = sut.$state.record()

        await sut.onButtonTapped()
        
        let expectedStates = [
            MyViewState.init(isLoading: false),
            MyViewState.init(isLoading: true),
            MyViewState.init(isLoading: true, url: expectedURL),
            MyViewState.init(isLoading: false, url: expectedURL)
        ]
        
        #expect(state.output == expectedStates)
    }
    
    // MARK: - Bad testes that don't cover state changes
    
    @Test func badExpectation() async {
        let expectedURL = URL(string: "https://google.com")!
        let apiClient = MockAPIClient { expectedURL }
        
        let sut = makeSUT(apiClient: apiClient)

        await sut.onButtonTapped()
        
        #expect(apiClient.getRandomUsefulLinkIsCalled)
        
        // It may look like everything is fine and works as expected.
        // But in fact, we don’t know how many times the VM changes `isLoading`,
        // how often it updates the URL, etc.
        // This is a problem because if the VM first sets an incorrect URL
        // and then updates it to the correct one, our view may try to open the URL twice
        // or even fail to open the expected URL, even if the expectation itself is correct.
        #expect(sut.state.url == expectedURL)
    }
}

private extension MyBadViewModelTests {
    func makeSUT(
        apiClient: MyUsefulLinksAPIClient
    ) -> MyBadViewModelImpl { .init(apiClient: apiClient) }
}
