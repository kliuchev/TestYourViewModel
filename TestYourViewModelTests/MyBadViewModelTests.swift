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
        
        let isLoading = sut.$isLoading.record()
        let isAlertShown = sut.$isAlertShown.record()
        let url = sut.$url.record()
    
        // trigger
        await sut.onGetRandomVideoButtonTapped()
        
        #expect(apiClient.getRandomUsefulLinkIsCalled)
        
        // here we know what was the initial state `false`
        // how it changes when the event was triggered `[true, false]`
        #expect(isLoading.output == [false, true, false])
        
        // here we check what was initial state and how it changes
        #expect(isAlertShown.output == [false, true])
        
        // here we know exactly that VM doesn't set URL when something when wrong
        #expect(url.output == [nil])
    }
    
    @Test func expectedToOpenURLAndShowLoadingState_whenAPIClientReturnsURL() async throws  {
        let expectedURL = URL(string: "https://google.com")!
        let apiClient = MockAPIClient { expectedURL }
        
        let sut = makeSUT(apiClient: apiClient)
        
        let isLoading = sut.$isLoading.record()
        let url = sut.$url.record()
        let isAlertShown = sut.$isAlertShown.record()

        await sut.onGetRandomVideoButtonTapped()
        
        #expect(apiClient.getRandomUsefulLinkIsCalled)
        #expect(isLoading.output == [false, true, false])
        #expect(url.output == [nil, expectedURL])
        #expect(isAlertShown.output == [false])
    }
    
    // MARK: - Bad testes that don't cover state changes
    
    @Test func badExpectation() async {
        let expectedURL = URL(string: "https://google.com")!
        let apiClient = MockAPIClient { expectedURL }
        
        let sut = makeSUT(apiClient: apiClient)

        await sut.onGetRandomVideoButtonTapped()
        
        #expect(apiClient.getRandomUsefulLinkIsCalled)
        
        // It may look like everything is fine and works as expected.
        // But in fact, we don’t know how many times the VM changes `isLoading`,
        // how often it updates the URL, etc.
        // This is a problem because if the VM first sets an incorrect URL
        // and then updates it to the correct one, our view may try to open the URL twice
        // or even fail to open the expected URL, even if the expectation itself is correct.
        #expect(sut.url == expectedURL)
    }
}

private extension MyBadViewModelTests {
    func makeSUT(
        apiClient: MyUsefulLinksAPIClient
    ) -> MyBadViewModelImpl { .init(apiClient: apiClient) }
}
