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
    func putHeroInMap() -> [CustomMKAnnotation]
}

final class MapHeroesViewModel {
    // MARK: - VARIABLES
    private var persistanceHeroes: [PersistenceHeros] = []
    private var networkManager: NetworkManager?
    var onSuccess: (() -> Void)?
    var onFailure: (() -> Void)?
    var createCustomMKAnnotation: ((PersistenceHeros) -> CustomMKAnnotation)?
    
    // MARK: - INITIALIZER
    init(networkManager: NetworkManager? = NetworkManager(),
         onSuccess: (() -> Void)? = nil,
         onFailure: (() -> Void)? = nil,
         createCustomMKAnnotation: ((PersistenceHeros) -> CustomMKAnnotation)? = nil) {
        self.networkManager = networkManager
        self.onSuccess = onSuccess
        self.onFailure = onFailure
        self.createCustomMKAnnotation = createCustomMKAnnotation
    }
    
    // MARK: - FUNCTIONS
    
    private func getPersistenceToken() -> String {
        guard let user = UserDefaultsHelper.getItems(key: .user) as? String else { return "" }
        guard let tokenData = keyChainHelper.standard.read(account: user, service: "Token") else { return "" }
        return String(data: tokenData, encoding: .utf8) ?? ""
        
    }
}

extension MapHeroesViewModel: MapHeroesViewModelProtocol {
    
    func onViewsLoaded() {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchHeroesFromCoreData), name: .heroesStoredInCoreData, object: nil)
    }
    
    // Call the API, receive the heroes and their locations and save them in Core Data
    func getCharacters() {
        fetchHeroesFromCoreData()
        let token = getPersistenceToken()
        
        guard let syncDate = UserDefaultsHelper.getSyncDate(key: .syncDate),
              syncDate.addingTimeInterval(1) > Date(),
              !persistanceHeroes.isEmpty else {
            networkManager?.fetchDragonBallData(from: Endpoint.getHeroesEndpoint.rawValue,
                                                requestBody: Body(name: ""),
                                                token: token, completion: { [weak self] (result: Result<[Hero]?, NetworkError>) in
                switch result {
                case .success(let heroesResponse):
                    var heroes: [Hero] = heroesResponse ?? []
                    heroes.enumerated().forEach { index, heroCoordenate in
                        self?.networkManager?.fetchDragonBallData(from: Endpoint.geolocationEndpoint.rawValue,
                                                                  requestBody: Body(id: heroCoordenate.id),
                                                                  token: token) { (result: Result<[Geolocation]?, NetworkError>) in
                            switch result {
                            case .success(let geolocations):
                                guard let geolocations = geolocations else { return }
                                let firstCordinate = geolocations.first
                                
                                if geolocations.isEmpty {
                                    DispatchQueue.main.async {
                                        CoreDataManager.shared.saveHeroes(with: heroes[index])
                                        UserDefaultsHelper.saveSyncDate(key: .syncDate)
                                    }
                                } else {
                                    heroes[index].latitud = Double(firstCordinate?.latitud ?? "0.0")
                                    heroes[index].longitud = Double(firstCordinate?.longitud ?? "0.0")
                                    DispatchQueue.main.async {
                                        CoreDataManager.shared.saveHeroes(with: heroes[index])
                                        UserDefaultsHelper.saveSyncDate(key: .syncDate)
                                        NotificationCenter.default.post(name: .heroesStoredInCoreData, object: self)
                                    }
                                }
                                
                            case .failure(_):
                                print("\(NetworkError.geolocationsError)")
                            }
                        }
                    }
                case .failure(_):
                    print("\(NetworkError.heroesError)")
                }
                
            })
            return
        }
        
    }
    
    func putHeroInMap() -> [CustomMKAnnotation] {
        var mkAnnotations: [CustomMKAnnotation] = []
        persistanceHeroes.forEach { persistanceHero in
            if persistanceHero.latitud != 0.0 && persistanceHero.longitud != 0.0 {
                if let characterLocation = createCustomMKAnnotation?(persistanceHero) {
                    mkAnnotations.append(characterLocation)
                }
            }
        }
        return mkAnnotations
    }
    
    // This function is executed when Notification Center notifies that the heroes has been saved succesfully to Core Data
    @objc func fetchHeroesFromCoreData() {
        CoreDataManager.shared.fetchHeroes { result in
            switch result {
            case .success(let heroes):
                self.persistanceHeroes = heroes ?? []
                onSuccess?()
            case .failure(let error):
                print("Fetch Heroes: \(error)")
            }
        }
    }
    
}

