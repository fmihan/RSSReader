//
//  LargeNewsArticleTableViewCell.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 27.01.2024..
//

import UIKit

class LargeNewsArticleTableViewCell: UITableViewCell {

    let image = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .systemGray3
    }

    let gradient = UIImageView().then {
        $0.tintColor = .black
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage.gradientBlackClear
    }

    let label = UILabel(
        text: "Text",
        textColor: .white,
        font: .systemFont(ofSize: 18, weight: .heavy)
    ).then {
        $0.numberOfLines = 3
    }

    let source = UILabel(
        text: "",
        textColor: .white,
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

    let overlayView = UIView().then {
        $0.isUserInteractionEnabled = false
        $0.backgroundColor = .systemGray.withAlphaComponent(0.3)
    }

    let ellipsisButton = UIButton().then {
        $0.setShadow()
        $0.tintColor = .white
        $0.setImage(UIImage(systemName: "ellipsis"), for: .normal)
    }

    let bookmarkButton = UIButton().then {
        $0.setShadow()
        $0.tintColor = .white
        $0.setImage(UIImage(systemName: "bookmark"), for: .normal)
    }

    var bookmarkAction: (() -> Void)?
    var ellipsisAction: (() -> Void)?

    var article: RSSItemWithInfo? {
        didSet {
            guard let article else { return }

            label.text = article.item?.title
            source.text = article.getPublisherAndTime()

            if let imageUrl = article.item?.imageUrl {
                image.setKFImage(from: imageUrl, placeholder: nil)
            }

            if let publisherImage = article.publisher?.image?.url {
                sourceImage.setKFImage(from: publisherImage, placeholder: .none)
            }

            category.text = article.item?.firstCategoryName
            overlayView.isHidden = article.item?.readDate == nil
            categoryContainer.isHidden = article.item?.hasCategories == false

            let imageName: String = article.item?.isFavorite == true ? "bookmark.fill" : "bookmark"
            bookmarkButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        image.image = nil
        sourceImage.image = nil
        categoryContainer.isHidden = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        contentView.addSubview(image)
        contentView.addSubview(gradient)
        contentView.addSubview(label)
        contentView.addSubview(source)
        contentView.addSubview(sourceImage)
        contentView.addSubview(categoryContainer)
        contentView.addSubview(overlayView)
        contentView.addSubview(ellipsisButton)
        contentView.addSubview(bookmarkButton)
        categoryContainer.addSubview(category)

        setupConstraints()
        setupActions()
    }

    private func setupConstraints() {

        image.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(230).priority(999)
        }

        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        gradient.snp.makeConstraints { make in
            make.edges.equalTo(image.snp.edges)
        }

        label.snp.makeConstraints { make in
            make.bottom.equalTo(source.snp.top).inset(-8)
            make.horizontalEdges.equalToSuperview().inset(8)
        }

        source.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().inset(8)
            make.bottom.equalTo(image.snp.bottom).inset(16)
        }

        sourceImage.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.top.equalTo(image.snp.top).offset(16)
            make.leading.equalTo(image.snp.leading).offset(8)
            make.trailing.lessThanOrEqualToSuperview()
        }

        category.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.bottom.equalToSuperview().offset(-2)
            make.leading.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().offset(-4)
        }

        categoryContainer.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.bottom.equalTo(label.snp.top).offset(-8)
        }

        ellipsisButton.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        bookmarkButton.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.top.equalToSuperview()
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
