//
//  MyRandomVideoAPIClient.swift
//  TestYourViewModel
//
//  Created by Sviatoslav on 29/08/2025.
//

import Foundation

protocol MyUsefulLinksAPIClient {
    func getRandomUsefulLink() async throws -> URL
}

enum MyUsefulLinksAPIClientError: Error {
    case notFound
}

final class MyUsefulLinksAPIClientImpl: MyUsefulLinksAPIClient {
    
    private let storage: [String] = [
        "https://medium.com/@sviatoslav.kliuchev/flutter-is-a-bad-choice-for-you-unless-its-not-a3f082897d3b",
        "https://medium.com/@sviatoslav.kliuchev/improve-asyncimage-in-swiftui-5aae28f1a331"
    ]
    
    func getRandomUsefulLink() async throws -> URL {
        try? await Task.sleep(for: .seconds(2))
        
        guard let absoluteURL = storage.randomElement(), let url = URL(string: absoluteURL) else {
            throw MyUsefulLinksAPIClientError.notFound
        }
        
        return url
    }
}
