//
//  HistoryViewController.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 02.02.2024..
//

import UIKit
import Combine

class HistoryViewController: UIViewController {

    var viewModel: HistoryViewModel!
    var cancellables = Set<AnyCancellable>()

    var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "history.title".localize()

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

        output.reloadRowPublisher
            .sink { [unowned self] indexPath in
                tableView?.reloadRows(at: [indexPath], with: .automatic)
            }
            .store(in: &cancellables)

        output.noItemsPublisher
            .sink { [unowned self] noItems in
                contentUnavailableConfiguration = noItems ? noHistory() : nil
                setNeedsUpdateContentUnavailableConfiguration()
            }
            .store(in: &cancellables)
    }

    private func noHistory() -> UIContentConfiguration {
        var noHistory = UIContentUnavailableConfiguration.empty()
        noHistory.image = UIImage(systemName: "clock.arrow.circlepath")
        noHistory.text = "no.results.history.feed.empty".localize()
        noHistory.secondaryText = "no.results.history.feed.empty.description".localize()
        return noHistory
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let item = viewModel.itemAt(row: indexPath.row)

        switch item.item?.size {
        case .small:
            let cell: SmallArticleTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.article = viewModel.itemAt(row: indexPath.row)
            cell.ellipsisAction = { [weak self] in
                self?.viewModel.actions(for: item.item)
            }
            cell.bookmarkAction = { [weak self] in
                self?.viewModel.bookmark(for: item.item)
            }
            return cell
        case .medium:
            let cell: MediumArticleTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.article = viewModel.itemAt(row: indexPath.row)
            cell.ellipsisAction = { [weak self] in
                self?.viewModel.actions(for: item.item)
            }
            cell.bookmarkAction = { [weak self] in
                self?.viewModel.bookmark(for: item.item)
            }
            return cell
        case .large:
            let cell: LargeNewsArticleTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.article = viewModel.itemAt(row: indexPath.row)
            cell.ellipsisAction = { [weak self] in
                self?.viewModel.actions(for: item.item)
            }
            cell.bookmarkAction = { [weak self] in
                self?.viewModel.bookmark(for: item.item)
            }
            return cell
        case nil:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = viewModel.itemAt(row: indexPath.row)
        viewModel.openWeb(for: item.item)
    }

}
