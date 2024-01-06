//
//  HeroDetailViewModel.swift
//  PracticaFinaliOSAvanzado
//
//  Created by Sergio Reina Montes on 06/01/2024.
//

import Foundation


class HeroDetailViewModel: HeroDetailViewControllerDelegate {
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol
    
    var viewState: ((HeroDetailViewState) -> Void)?
    private var hero: Hero
    private var heroLocations: HeroLocations = []
    
    init(hero: Hero, apiProvider: ApiProviderProtocol, secureDataProvider: SecureDataProviderProtocol) {
        self.hero = hero
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
    }
    
    func onViewAppear() {
        viewState?(.loading(true))
        
        DispatchQueue.global().async {
            defer { self.viewState?(.loading(false))}
            guard let token = self.secureDataProvider.getToken() else { return }
            
            self.apiProvider.getLocations(
                by: self.hero.id,
                token: token) { [ weak self ] heroLocations in
                    self?.heroLocations = heroLocations
                    self?.viewState?(.update(hero: self?.hero, locations: heroLocations))
                }
        }
    }
}
