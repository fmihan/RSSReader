//
//  FeedViewController.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 26.01.2024..
//

import UIKit
import SwiftUI
import Combine
import RealmSwift
import FeedKit

class FeedViewController: UIViewController {

    var viewModel: FeedViewModel!

    var tableView: UITableView?
    var cancellables = Set<AnyCancellable>()

    var data: [RSSItemWithInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    func setupUI() {
        view.backgroundColor = .systemGray2
        addTableView()
    }

    func addTableView() {
        tableView = UITableView()
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.separatorStyle = .singleLine
        tableView?.showsVerticalScrollIndicator = false

        registrCollectionViewNibs()

        guard let tableView else { return }

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func registrCollectionViewNibs() {
        tableView?.register(SmallArticleTableViewCell.self)
        tableView?.register(MediumArticleTableViewCell.self)
        tableView?.register(LargeNewsArticleTableViewCell.self)
    }

    func bindViewModel() {
        let output = viewModel.transform()
        
        output.reloadPublisher
            .sink { [unowned self] in
                tableView?.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let item = viewModel.itemAt(row: indexPath.row)

        switch item.item?.size {
        case .small:
            let cell: SmallArticleTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.article = viewModel.itemAt(row: indexPath.row)
            return cell
        case .medium:
            let cell: MediumArticleTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.article = viewModel.itemAt(row: indexPath.row)
            return cell
        case .large:
            let cell: LargeNewsArticleTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.article = viewModel.itemAt(row: indexPath.row)
            return cell
        case nil:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
