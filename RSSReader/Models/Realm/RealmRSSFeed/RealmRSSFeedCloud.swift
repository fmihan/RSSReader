//
//  RealmRSSFeedCloud.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 30.01.2024..
//

import FeedKit
import Foundation
import RealmSwift

class RealmRSSFeedCloud: Object {

    @Persisted(primaryKey: true) var id: String = UUID().uuidString

    /// The domain to register notification to.
    @Persisted var domain: String?

    /// The port to connect to.
    @Persisted var port: Int?

    /// The path to the RPC service. e.g. "/RPC2".
    @Persisted var path: String?

    /// The procedure to call. e.g. "myCloud.rssPleaseNotify" .
    @Persisted var registerProcedure: String?

    /// The `protocol` specification. Can be HTTP-POST, XML-RPC or SOAP 1.1 -
    /// Note: "protocol" is a reserved keyword, so `protocolSpecification`
    /// is used instead and refers to the `protocol` attribute of the `cloud`
    /// element.
    @Persisted var protocolSpecification: String?

}

extension RealmRSSFeedCloud {

    func assignValues(from cloud: RSSFeedCloud? ) {
        guard let cloud else { return }
        domain = cloud.attributes?.domain
        port = cloud.attributes?.port
        path = cloud.attributes?.path
        registerProcedure = cloud.attributes?.registerProcedure
        protocolSpecification = cloud.attributes?.protocolSpecification
    }

}
