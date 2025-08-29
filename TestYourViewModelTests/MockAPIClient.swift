//
//  MockAPIClient.swift
//  TestYourViewModel
//
//  Created by Sviatoslav on 29/08/2025.
//

import Foundation
@testable import TestYourViewModel

final class MockAPIClient: MyUsefulLinksAPIClient {
    
    private var closure: () async throws -> URL
    
    public private(set) var getRandomUsefulLinkCallsCount = 0
    public var getRandomUsefulLinkIsCalled: Bool { getRandomUsefulLinkCallsCount > 0 }
    
    init(closure: @escaping () async throws -> URL) {
        self.closure = closure
    }
    
    func getRandomUsefulLink() async throws -> URL {
        getRandomUsefulLinkCallsCount += 1
        return try await closure()
    }
}
