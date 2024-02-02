//
//  AppDependency.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 31.01.2024..
//

import Foundation

protocol HasRealmService {
    var realmService: RealmServiceProtocol { get }
}

protocol HasNetworkMonitroService {
    var networkMonitorService: NetworkMonitorServiceProtocol { get }
}

protocol HasFeedService {
    var feedService: FeedServiceProtocol { get }
}

protocol HasRSSReaderApi {
    var api: RSSReaderApiProtocol { get }
}

class AppDependency: HasRealmService, HasNetworkMonitroService, HasFeedService, HasRSSReaderApi {

    var api: RSSReaderApiProtocol
    var feedService: FeedServiceProtocol
    var realmService: RealmServiceProtocol
    var networkMonitorService: NetworkMonitorServiceProtocol

    init() {
        self.api = RSSReaderApi()
        self.realmService = RealmService()
        self.networkMonitorService = NetworkMonitorService()
        self.feedService = FeedService(realm: realmService, api: api)
    }

}
