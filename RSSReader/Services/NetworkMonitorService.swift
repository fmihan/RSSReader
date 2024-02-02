//
//  NetworkMonitorService.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 31.01.2024..
//

import Foundation
import Network
import Combine

class NetworkMonitorService: NetworkMonitorServiceProtocol {
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitor")

    private var cancellables = Set<AnyCancellable>()

    private let isConnectedSubject = CurrentValueSubject<Bool, Never>(true)
    var isConnectedPublisher: AnyPublisher<Bool, Never> {
        return isConnectedSubject.eraseToAnyPublisher()
    }

    var isConnected: Bool {
        return monitor.currentPath.status == .satisfied
    }

    init() {
        self.monitor = NWPathMonitor()
        startMonitoring()
        observe()
    }

    private func observe() {
        isConnectedPublisher
            .removeDuplicates()
            .sink {
                fprint($0 ? "Network connected" : "No network connection", type: .network, isError: !$0)
            }.store(in: &cancellables)
    }

    private func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnectedSubject.send(path.status == .satisfied)
        }
    }

    private func stopMonitoring() {
        monitor.cancel()
    }
}

