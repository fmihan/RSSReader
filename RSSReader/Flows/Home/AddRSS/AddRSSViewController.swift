//
//  AddRSSViewController.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 02.02.2024..
//

import UIKit
import Combine
import SnapKit

class AddRSSViewController: UIViewController {

    private var searchTextSubject = PassthroughSubject<String?, Never>()
    var viewModel: AddRSSViewModel!
    var cancellables = Set<AnyCancellable>()

    var tableView: UITableView?
    let search = UISearchController(searchResultsController: nil).then {
        $0.searchBar.searchTextField.placeholder = "add.rss.search.placeholder".localize()
        $0.obscuresBackgroundDuringPresentation = false
        $0.hidesNavigationBarDuringPresentation = false
    }

    lazy var addSource = UIButton().then {
        $0.tintColor = .systemRed
        $0.configuration = .borderedProminent()
        $0.setTitle("add.rss.button.title".localize(), for: .normal)
        $0.addAction(UIAction(handler: { [unowned self] _ in
            Haptics.shared.play(.rigid)
            viewModel.add()
        }), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "add.rss.source.title".localize()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        search.searchBar.becomeFirstResponder()
        bindViewModel()
    }

    func setupUI() {
        view.backgroundColor = .systemBackground

        addSearch()
        addButton()
        addTableView()
    }

    func addSearch() {
        search.searchBar.delegate = self
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    func addButton() {
        view.addSubview(addSource)
        addSource.alpha = 0
        addSource.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    func addTableView() {
        tableView = UITableView()
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.backgroundColor = .clear
        tableView?.separatorInset.left = 60
        tableView?.keyboardDismissMode = .onDrag
        tableView?.showsVerticalScrollIndicator = false

        tableView?.register(PublisherTableViewCell.self)
        tableView?.register(SmallArticleTableViewCell.self)

        guard let tableView else { return }

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(addSource.snp.top).offset(-8)
        }

        view.sendSubviewToBack(tableView)
    }


    func bindViewModel() {
        let input = AddRSSViewModel.Input(
            searchTextPublisher: searchTextSubject.eraseToAnyPublisher()
        )

        let output = viewModel.transform(input: input)

        output.reloadPublisher
            .sink { [unowned self] in
                tableView?.reloadData()
            }
            .store(in: &cancellables)

        output.noRSSFeedPublisher
            .sink { [unowned self] noFeed in
                animateButton(isHidden: noFeed)
                contentUnavailableConfiguration = noFeed ? validateRSSFormat() : nil
                setNeedsUpdateContentUnavailableConfiguration()
            }
            .store(in: &cancellables)

        output.sourceAdded
            .sink { [unowned self] in
                animateButton(isHidden: true)
                Toast.show(for: .addedNewFeed, controller: self)
            }
            .store(in: &cancellables)
    }

    private func animateButton(isHidden: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.addSource.alpha = isHidden ? 0 : 1
            self.addSource.snp.remakeConstraints { make in
                make.height.equalTo(56)
                make.horizontalEdges.equalToSuperview().inset(16)
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(isHidden ? 56 : 0)
            }
            self.view.layoutIfNeeded()
        }
    }

    private func validateRSSFormat() -> UIContentConfiguration {
        var invalidRSS = UIContentUnavailableConfiguration.empty()
        invalidRSS.image = UIImage(systemName: "questionmark.square.fill")
        invalidRSS.imageProperties.tintColor = .systemRed
        invalidRSS.text = "no.results.add.rss.empty".localize()
        invalidRSS.secondaryText = "no.results.add.rss.empty.description".localize()
        return invalidRSS
    }

}

extension AddRSSViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: PublisherTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.rssFeed = viewModel.rssFeed
            return cell
        } else {
            let cell: SmallArticleTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.rssItem = viewModel.item(for: indexPath.row)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section > 0 {
            viewModel.openLink(link: viewModel.item(for: indexPath.row)?.link)
        }
    }

}

extension AddRSSViewController: UISearchBarDelegate {

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchTextSubject.send(nil)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTextSubject.send(searchText)
    }
}
