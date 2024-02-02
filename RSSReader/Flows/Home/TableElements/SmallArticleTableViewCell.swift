//
//  SmallArticleTableViewCell.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 01.02.2024..
//

import UIKit
import FeedKit

class SmallArticleTableViewCell: UITableViewCell {

    let label = UILabel(
        text: "Text",
        textColor: .label,
        font: .systemFont(ofSize: 17, weight: .bold)
    ).then {
        $0.numberOfLines = 0
    }

    let source = UILabel(
        text: "",
        textColor: .label,
        font: .systemFont(ofSize: 10, weight: .regular)
    )

    let sourceImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    let categoryContainer = UIView().then {
        $0.layer.cornerRadius = 4
        $0.backgroundColor = .systemGray5
    }

    let category = UILabel(
        text: "",
        textColor: .label,
        font: .systemFont(ofSize: 10, weight: .medium)
    )

    let hStack = UIStackView().then {
        $0.spacing = 4
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
    }

    let ellipsisButton = UIButton().then {
        $0.setShadow()
        $0.tintColor = .label
        $0.setImage(UIImage(systemName: "ellipsis"), for: .normal)
    }

    let bookmarkButton = UIButton().then {
        $0.setShadow()
        $0.tintColor = .label
        $0.setImage(UIImage(systemName: "bookmark"), for: .normal)
    }

    var bookmarkAction: (() -> Void)?
    var ellipsisAction: (() -> Void)?

    var article: RSSItemWithInfo? {
        didSet {
            guard let article else { return }

            label.text = article.item?.title
            source.text = article.getPublisherAndTime()
            sourceImage.isHidden = article.publisher?.image?.url == nil

            if let publisherImage = article.publisher?.image?.url {
                sourceImage.setKFImage(from: publisherImage, placeholder: .none)
            }

            category.text = article.item?.firstCategoryName
            categoryContainer.isHidden = article.item?.hasCategories == false
        }
    }

    var rssItem: RSSFeedItem? {
        didSet {
            guard let rssItem else { return }

            sourceImage.isHidden = true
            bookmarkButton.isHidden = true
            ellipsisButton.isHidden = true
            categoryContainer.isHidden = true

            label.text = rssItem.title
            source.text = DateUtils.timeAgo(from: rssItem.pubDate) ?? ""
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        sourceImage.image = nil
        categoryContainer.isHidden = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        contentView.addSubview(label)
        contentView.addSubview(hStack)
        contentView.addSubview(ellipsisButton)
        contentView.addSubview(categoryContainer)
        contentView.addSubview(ellipsisButton)
        contentView.addSubview(bookmarkButton)

        hStack.addArrangedSubview(sourceImage)
        hStack.addArrangedSubview(source)
        categoryContainer.addSubview(category)

        setupConstraints()
        setupActions()
    }

    private func setupConstraints() {

        category.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.bottom.equalToSuperview().offset(-2)
            make.leading.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().offset(-4)
        }

        categoryContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
        }

        label.snp.makeConstraints { make in
            make.top.equalTo(categoryContainer.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(8)
        }

        hStack.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().offset(-16)
        }

        sourceImage.snp.makeConstraints { make in
            make.size.equalTo(16)
        }

        ellipsisButton.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.top.equalToSuperview().offset(-4)
            make.trailing.equalToSuperview()
        }

        bookmarkButton.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.top.equalToSuperview().offset(-4)
            make.trailing.equalTo(ellipsisButton.snp.leading).inset(8)
        }
    }

    private func setupActions() {
        bookmarkButton.addAction(UIAction(handler: { [weak self] _ in
            self?.bookmarkAction?()
        }), for: .touchUpInside)

        ellipsisButton.addAction(UIAction(handler: { [weak self] _ in
            self?.ellipsisAction?()
        }), for: .touchUpInside)
    }

}

