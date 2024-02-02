//
//  MainHomepageViewController.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 02.02.2024..
//

import UIKit
import Combine
import Parchment

class MainHomepageViewController: UIViewController {

    // MARK: Variables
    var viewModel: MainHomepageViewModel!
    var cancellables = Set<AnyCancellable>()

    // MARK:  UI Elements
    var pagingViewController: PagingViewController?

    // MARK: Lifecycle
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

    // MARK: UI
    func setupUI() {
        view.backgroundColor = .systemBackground

        addParchment()
        addLoader()
    }

    func addParchment() {
        pagingViewController = PagingViewController()
        guard let pagingViewController else { return }
        pagingViewController.delegate = self
        pagingViewController.dataSource = self
        pagingViewController.view.isHidden = true

        pagingViewController.textColor = .label
        pagingViewController.indicatorColor = .systemRed
        pagingViewController.selectedTextColor = .systemRed
        pagingViewController.menuBackgroundColor = .systemBackground
        pagingViewController.menuItemSize = .selfSizing(estimatedWidth: 50, height: 42)
        pagingViewController.indicatorOptions = .visible(height: 2, zIndex: Int.max, spacing: .zero, insets: .zero)

        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false

        pagingViewController.view.snp.makeConstraints { make in
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide.snp.verticalEdges)
            make.horizontalEdges.equalToSuperview()
        }
    }

    // MARK: Binding
    func bindViewModel() {
        let output = viewModel.transform()

        output.reloadPublisher
            .sink { [unowned self] in
                pagingViewController?.reloadMenu()
                pagingViewController?.reloadData()
            }
            .store(in: &cancellables)

        output.noResultsPublisher
            .sink { [unowned self] noResults in
                pagingViewController?.view.isHidden = noResults
                contentUnavailableConfiguration = noResults ? noFeed() : nil
                setNeedsUpdateContentUnavailableConfiguration()
            }
            .store(in: &cancellables)
    }

    private func noFeed() -> UIContentConfiguration {
        var noDataConfig = UIContentUnavailableConfiguration.empty()
        noDataConfig.image = UIImage(systemName: "newspaper.fill")
        noDataConfig.text = "no.results.home.feed.empty".localize()
        noDataConfig.secondaryText = "no.results.home.feed.empty.description".localize()

        var addFeed = UIButton.Configuration.borderless()
        addFeed.image = UIImage(systemName: "plus")
        addFeed.title = "no.results.home.feed.add.feed.button".localize()
        addFeed.baseBackgroundColor = .systemRed
        addFeed.baseForegroundColor = .systemRed
        noDataConfig.button = addFeed

        noDataConfig.buttonProperties.primaryAction = UIAction(handler: { [unowned self]  _ in
            viewModel.addFeed()
        })

        return noDataConfig
    }
}

extension MainHomepageViewController: PagingViewControllerDataSource, PagingViewControllerDelegate {

    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        viewModel.numberOfItems()
    }

    func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        if viewModel.hasMixedFeed() {
            let publisherId: String? = index == 0 ? nil : viewModel.getPublisherId(for: index)
            let mixedFeedViewController = UIViewControllerFactory.createFeedViewController(withPublisherId: publisherId)
            return mixedFeedViewController
        } else {
            let mixedFeedViewController = UIViewControllerFactory.createFeedViewController()
            return mixedFeedViewController
        }
    }

    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        return PagingIndexItem(
            index: index,
            title: viewModel.pageTitle(for: index)
        )
    }
}
