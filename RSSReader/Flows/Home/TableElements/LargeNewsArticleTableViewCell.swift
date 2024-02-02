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

    var article: RSSItemWithInfo? {
        didSet {
            guard let article else { return }

            image.image = nil
            if let imageUrl = article.item?.imageUrl {
                image.setKFImage(from: imageUrl, placeholder: nil)
            }

            //image.setKFImage(from: article.item?.imageUrl, placeholder: nil)
            label.text = article.item?.title
            source.text = (article.publisher?.title ?? "") + " • " + (DateUtils.timeAgo(from: article.item?.pubDate) ?? "Kurcina" )

            if let publisherImage = article.publisher?.image?.url {
                sourceImage.setKFImage(from: publisherImage, placeholder: .none)
            } else {
                sourceImage.image = nil
            }

            if let articleCategory = article.item?.categories.first {
                category.text = articleCategory.value
                categoryContainer.isHidden = false
            } else {
                categoryContainer.isHidden = true
            }
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
        contentView.addSubview(image)
        contentView.addSubview(gradient)
        contentView.addSubview(label)
        contentView.addSubview(source)
        contentView.addSubview(sourceImage)
        contentView.addSubview(categoryContainer)
        contentView.addSubview(ellipsisButton)
        contentView.addSubview(bookmarkButton)
        categoryContainer.addSubview(category)


        setupConstraints()
    }

    private func setupConstraints() {

        image.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(230).priority(999)
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
            make.height.equalTo(20)
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

}
