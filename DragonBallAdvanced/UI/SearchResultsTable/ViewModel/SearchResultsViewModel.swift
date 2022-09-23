//
//  SearchResultsViewModel.swift
//  DragonBallAdvanced
//
//  Created by Fran Alarza on 19/9/22.
//

import Foundation

protocol SearchResultsViewModelProtocol {
    var heroResultCount: Int { get }
    func fetchResultHeroes(with predicate: NSPredicate)
    func getPersistenceHero(from index: Int) -> PersistenceHeros
}

class SearchResultsViewModel {
    // MARK: - VARIBLES
    weak var delegate: SearchResultsDelegateProtocol?
    var searchResult: [PersistenceHeros] = []
    
    init(delegate: SearchResultsDelegateProtocol) {
        self.delegate = delegate
    }
    
    // MARK: - FUNCTIONS
}

extension SearchResultsViewModel: SearchResultsViewModelProtocol {
    var heroResultCount: Int {
        searchResult.count
    }
    
    func fetchResultHeroes(with predicate: NSPredicate) {
        CoreDataManager.shared.fetchHeroes(predicate: predicate) { result in
            switch result {
            case .success(let result):
                self.searchResult = result ?? []
                delegate?.reloadTable()
            case .failure(let error):
                print("Error al descargar los resultados: \(error)")
            }
        }
    }
    
    func getPersistenceHero(from index: Int) -> PersistenceHeros {
        searchResult[index]
    }
    
    
}
