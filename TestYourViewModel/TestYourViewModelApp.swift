//
//  TestYourViewModelApp.swift
//  TestYourViewModel
//
//  Created by Sviatoslav on 29/08/2025.
//

import SwiftUI

@main
struct TestYourViewModelApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                List {
                    NavigationLink {
                        MyView(viewModel: MyViewModelImpl(apiClient: MyUsefulLinksAPIClientImpl()))
                            .navigationTitle("Correct")
                    } label: {
                        Text("Correct behavior")
                    }
                    
                    NavigationLink {
                        MyView(viewModel: MyBadViewModelImpl(apiClient: MyUsefulLinksAPIClientImpl()))
                            .navigationTitle("Incorrect")
                    } label: {
                        Text("Incorrect behavior")
                    }
                }
            }
        }
    }
}
