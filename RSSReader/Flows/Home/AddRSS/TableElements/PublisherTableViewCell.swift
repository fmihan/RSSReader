//
//  PublisherTableViewCell.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 02.02.2024..
//

import UIKit
import FeedKit

class PublisherTableViewCell: UITableViewCell {

    let title = UILabel(
        text: "",
        textColor: .label,
        font: .systemFont(ofSize: 17, weight: .bold)
    ).then {
        $0.numberOfLines = 0
    }

    let publisherDescription = UILabel(
        text: "",
        textColor: .label,
        font: .systemFont(ofSize: 12)
    ).then {
        $0.numberOfLines = 0
    }

    var rssFeed: RSSFeed? {
        didSet {
            guard let rssFeed else { return }
            title.text = rssFeed.title
            publisherDescription.text = rssFeed.description
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        selectionStyle = .none
        backgroundColor = .systemRed.withAlphaComponent(0.4)

        contentView.addSubview(title)
        contentView.addSubview(publisherDescription)

        setupConstraints()
    }

    private func setupConstraints() {
        title.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.horizontalEdges.equalToSuperview().inset(8)
        }

        publisherDescription.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().offset(-16)
        }
    }

}
