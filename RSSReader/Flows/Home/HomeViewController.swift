//
//  HomeViewController.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 26.01.2024..
//

import UIKit
import SwiftUI
import Combine
import RealmSwift
import FeedKit

class HomeViewController: UIViewController {

    var viewModel: HomeViewModel!

    var tableView: UITableView?
    var cancellables = Set<AnyCancellable>()

    var data: [RSSItemWithInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
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

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1 {
            let cell: MediumArticleTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.article = viewModel.itemAt(row: indexPath.row)
            return cell
        }

        if indexPath.row == 3 {
            let cell: SmallArticleTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.article = viewModel.itemAt(row: indexPath.row)
            return cell
        }

        let cell: LargeNewsArticleTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.article = viewModel.itemAt(row: indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension HomeViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(text: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.search(text: "")
    }
}

