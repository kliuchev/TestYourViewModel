//
//  MyViewState.swift
//  TestYourViewModel
//
//  Created by Sviatoslav on 30/08/2025.
//

import Foundation

struct MyViewState: Equatable {
    var isLoading: Bool = false
    var isAlertShown: Bool = false
    var url: URL?
}
