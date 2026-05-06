//
//  MainViewModel.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 06/05/2026.
//

import Foundation
import Combine

class MainViewModel: ObservableObject {
    let api = ApiManager.shared
    
    var cancellables: Set<AnyCancellable>
    
    @Published var isLoading = false
    
    @Published var phaseFetch: DataFetchPhase<Any> = .empty
    @Published var fetchTaskToken: FetchTaskToken
    
    let identity: ObjectIdentifier
    
    init (_ id: ObjectIdentifier) {
        self.identity = id
        cancellables = Set()
        fetchTaskToken = FetchTaskToken(token: Date())
        Task {
            await phaseFetchingSubscriber()
        }
        isLoading = true
        phaseFetch = .loading
    }
    
    @MainActor
    private func phaseFetchingSubscriber() {
        $phaseFetch.sink { [weak self] phase in
            guard let self else { return }
                if case .loading = phase {
                    self.isLoading = true
                } else {
                    self.isLoading = false
                }
        }.store(in: &cancellables)
    }
     
    func setPhaseToLoading() {
        if case .success(_) = phaseFetch, case .error(_) = phaseFetch, case .empty = phaseFetch {
                self.phaseFetch = .loading
        }
    }
     
    func setError(_ error: Error) {
        debugPrint("Error: \(error)")
        self.isLoading = false
        self.phaseFetch = .error(error)
    }
}

extension MainViewModel: Hashable {
    static func == (lhs: MainViewModel, rhs: MainViewModel) -> Bool {
        lhs.identity == rhs.identity
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identity)
    }
}
