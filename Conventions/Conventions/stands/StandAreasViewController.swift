//
//  StandAreasViewController.swift
//  Conventions
//

import SwiftUI

class StandAreasViewController: BaseViewController {

    private let searchController = UISearchController(searchResultsController: nil)
    private let searchState = StandAreasSearchState()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "אזורי דוכנים"
        configureSearchController()
        embedSwiftUIContent()
    }

    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "חיפוש דוכנים"
        searchController.searchBar.semanticContentAttribute = .forceRightToLeft
        searchController.searchBar.searchTextField.semanticContentAttribute = .forceRightToLeft
        searchController.searchBar.searchTextField.textAlignment = .right
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        if #available(iOS 26.0, *) {
            navigationItem.preferredSearchBarPlacement = .stacked
        }
    }

    private func embedSwiftUIContent() {
        let rootView = StandAreasView(
            refresher: Convention.instance.stands,
            searchState: searchState,
            onSelectArea: { [weak self] area in
                self?.selectArea(area)
            },
            onOpenFilter: { [weak self] in
                self?.openFilter()
            }
        )

        let hostingController = UIHostingController(rootView: rootView)
        hostingController.view.backgroundColor = .clear

        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        hostingController.didMove(toParent: self)
    }

    private func selectArea(_ area: String) {
        let viewController = StandsListViewController()
        viewController.area = area
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func openFilter() {
        let viewController = StandsFilterViewController()
        viewController.stands = Convention.instance.stands.getAll()
        viewController.filterState = searchState
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension StandAreasViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchState.searchText = searchController.searchBar.text ?? ""
    }
}

extension StandAreasViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        searchState.isActive = true
    }

    func willDismissSearchController(_ searchController: UISearchController) {
        searchState.isActive = false
        searchState.selectedCategories = []
    }
}
