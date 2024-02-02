//
//  OfflinePreviewViewController.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 02.02.2024..
//

import UIKit

class OfflinePreviewViewController: UIViewController {

    private let scrollView = UIScrollView()

    private let titleLabel = UILabel(
        text: "",
        textColor: .label,
        font: .systemFont(ofSize: 22, weight: .bold)
    )

    private let descriptionLabel = UILabel(
        text: "",
        textColor: .systemGray6,
        font: .systemFont(ofSize: 17, weight: .regular)
    )

    var item: RealmRSSFeedItem?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupItem()
    }

    func setupItem() {
        titleLabel.text = item?.title
        descriptionLabel.text = item?.description
    }

    func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        descriptionLabel.addSubview(descriptionLabel)

        setupContraints()
    }

    private func setupContraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(scrollView).offset(20)
            make.leading.trailing.equalTo(scrollView).inset(16)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalTo(scrollView).inset(16)
        }
    }

}
