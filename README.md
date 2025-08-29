# TestYourViewModel

A simple iOS demo project that shows **how to properly test your ViewModels**.

The main idea:  
When testing, we often focus only on the **triggered event** (e.g. `onAppear()`) and the **final state** of the ViewModel.  
But this approach can miss important **intermediate states** like loading indicators.

This project provides two examples:

- ✅ **Good tests** — verify the **full state transitions** of the ViewModel.
- ❌ **Bad tests** — check only the final result, ignoring important intermediate states.

---

## Motivation

Testing ViewModels isn’t only about checking the final values.  
We want to make sure the ViewModel reacts correctly to events and goes through all expected state changes.

For example:
- User opens a screen → `onAppear()` is called  
- ViewModel sets `isLoading = true`  
- Data loads…  
- ViewModel sets `isLoading = false`  

If we test **only the final state**, we might miss bugs like:
- `isLoading` never set to `true`
- Loading never ends
- Wrong order of transitions  

---

## ViewModels

### ✅ MyViewModel (good implementation)

```swift
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
```

### ❌ MyBadViewModel (bad implementation)

```swift
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
```

