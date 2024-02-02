//
//  MoreViewController.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 02.02.2024..
//

import UIKit
import Combine

class MoreViewController: UIViewController {

    var viewModel: MoreViewModel!
    var cancellables = Set<AnyCancellable>()

    // MARK: UI
    var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "more.title".localize()
        addTableView()
    }

    func addTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.backgroundColor = .clear
        tableView?.showsVerticalScrollIndicator = false

        guard let tableView else { return }

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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

extension MoreViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseID")

        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "reuseID")
        }

        guard let cell = cell else {
            assertionFailure("Failed to get a cell!")
            return UITableViewCell()
        }

        let item = viewModel.row(for: indexPath.row)
        var content = cell.defaultContentConfiguration()
        content.text = item.title
        content.image = item.icon
        content.imageProperties.tintColor = item.tintColor
        cell.contentConfiguration = content
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let action = viewModel.row(for: indexPath.row)
        viewModel.action(action)
    }

}

