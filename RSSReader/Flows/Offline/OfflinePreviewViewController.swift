//
//  OfflinePreviewViewController.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 02.02.2024..
//

import UIKit

class OfflinePreviewViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let titleLabel = UILabel(
        text: "",
        textColor: .label,
        font: .systemFont(ofSize: 22, weight: .bold)
    ).then {
        $0.numberOfLines = 0
    }

    private let descriptionLabel = UILabel(
        text: "",
        textColor: .systemGray,
        font: .systemFont(ofSize: 17, weight: .regular)
    ).then {
        $0.numberOfLines = 0
    }

    var item: RealmRSSFeedItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupItem()
    }

    func setupItem() {
        titleLabel.text = item?.title
        descriptionLabel.text = item?.feedItemDescription
    }

    func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)

        setupContraints()
    }

    private func setupContraints() {
        scrollView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        contentView.snp.makeConstraints { make in
            make.centerX.width.top.bottom.equalTo(scrollView)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }

}
