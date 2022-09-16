//
//  MapHeroesViewModel.swift
//  DragonBallAdvanced
//
//  Created by Fran Alarza on 11/9/22.
//

import Foundation

protocol MapHeroesViewModelProtocol {
    func onViewsLoaded()
    func getCharacters()
    func fetchHeroesFromCoreData()
    func putHeroInMap()
}

class MapHeroesViewModel {
    // MARK: - CONSTANTS
    private let networkManager = NetworkManager()
    
    // MARK: - VARIABLES
    private weak var delegate: MapHeroesProtocol?
    private var persistanceHeroes: [PersistenceHeros] = []
    
    init(delegate: MapHeroesProtocol) {
        self.delegate = delegate
    }
    
    // MARK: - FUNCTIONS
    
    private func getPersistenceToken() -> String {
        guard let tokenData = keyChainHelper.standard.read(account: "franalarza@gmail.com", service: "Token") else { return "" }
        return String(data: tokenData, encoding: .utf8) ?? ""
        
    }
}

extension MapHeroesViewModel: MapHeroesViewModelProtocol {
    
    func onViewsLoaded() {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchHeroesFromCoreData), name: .heroesStoredInCoreData, object: nil)
    }
    
    func getCharacters() {
        let token = getPersistenceToken()
        networkManager.fetchDragonBallData(from: Endpoint.getHeroesEndpoint.rawValue,
                                           requestBody: Body(name: ""),
                                           token: token,
                                           type: [Hero].self) { [weak self] heroesResponse, _ in
            var heroes: [Hero] = heroesResponse ?? []
            heroes.enumerated().forEach { index, heroCoordenate in
                self?.networkManager.fetchDragonBallData(from: Endpoint.geolocationEndpoint.rawValue,
                                                         requestBody: Body(id: heroCoordenate.id), token: token,
                                                         type: [Geolocation].self) { geolocations, _ in
                    guard let geolocations = geolocations else { return }
                    let firstCordinate = geolocations.first
                    
                    if geolocations.isEmpty {
                        DispatchQueue.main.async {
                            CoreDataManager.shared.saveHeroes(with: heroes[index])
                        }
                    } else {
                        heroes[index].latitud = Double(firstCordinate?.latitud ?? "0.0")
                        heroes[index].longitud = Double(firstCordinate?.longitud ?? "0.0")
                        DispatchQueue.main.async {
                            CoreDataManager.shared.saveHeroes(with: heroes[index])
                            NotificationCenter.default.post(name: .heroesStoredInCoreData, object: self)
                        }
                    }
                }
            }
        }
        
    }
    
    @objc func fetchHeroesFromCoreData() {
        CoreDataManager.shared.fetchHeroes { result in
            switch result {
            case .success(let heroes):
                self.persistanceHeroes = heroes ?? []
                putHeroInMap()
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    func putHeroInMap() {
        persistanceHeroes.forEach { persistanceHero in
            if persistanceHero.latitud != 0.0 && persistanceHero.longitud != 0.0 {
                delegate?.createPointAnnotation(with: persistanceHero)
            }
        }
    }
    
}

