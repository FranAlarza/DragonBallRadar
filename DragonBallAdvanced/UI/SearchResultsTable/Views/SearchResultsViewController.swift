//
//  SearchResultsViewController.swift
//  DragonBallAdvanced
//
//  Created by Fran Alarza on 19/9/22.
//

import UIKit

protocol SearchResultsDelegateProtocol: AnyObject {
    func reloadTable()
}

class SearchResultsViewController: UIViewController {
    // MARK: - VARIABLES
    var viewModel: SearchResultsViewModelProtocol?
    
    // MARK: - IBOUTLETS
    @IBOutlet weak var searchResultsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        configureSearchResultsTable()
    }
    
    // MARK: - FUNCTIONS
    func configureSearchResultsTable() {
        searchResultsTable.delegate = self
        searchResultsTable.dataSource = self
        searchResultsTable.register(UINib(nibName: SearchResultTableViewCell.idententifier, bundle: nil),
                                    forCellReuseIdentifier: SearchResultTableViewCell.idententifier)
    }
    
}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.heroResultCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.idententifier, for: indexPath) as? SearchResultTableViewCell else { return  UITableViewCell()}
        guard let hero = viewModel?.getPersistenceHero(from: indexPath.row) else { return UITableViewCell() }
        cell.setData(with: hero)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let hero = viewModel?.getPersistenceHero(from: indexPath.row) else { return }
        let detailController = DetailViewController()
        detailController.hero = hero
        present(detailController, animated: true)
    }
}

extension SearchResultsViewController: SearchResultsDelegateProtocol {
    func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            self?.searchResultsTable.reloadData()
        }
    }
}
