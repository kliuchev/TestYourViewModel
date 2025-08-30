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

## Tests

### ✅ Good tests (cover state changes)

```swift
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
```

### ❌ Bad test (ignore state changes)

```swift
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
```

