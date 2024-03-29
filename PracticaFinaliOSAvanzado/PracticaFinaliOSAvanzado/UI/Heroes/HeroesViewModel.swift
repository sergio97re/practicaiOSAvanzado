//
//  HeroesViewModel.swift
//  PracticaFinaliOSAvanzado
//
//  Created by Sergio Reina Montes on 04/01/2024.
//

import Foundation
import CoreData


class HeroesViewModel: HeroesViewControllerDelegate {
    //MARK: - Dependencies -
    private let apiProvider: ApiProviderProtocol
    private let securaDataProvider: SecureDataProviderProtocol
    
    //MARK: - Properties -
    var viewState: ((HeroesViewState) -> Void)?
    var heroesCount: Int {
        heroes.count
    }
    
    
    private var heroes: Heroes = []
    
    //MARK: - Initializers -
    init(apiProvider: ApiProviderProtocol,
         secureDataProvider: SecureDataProviderProtocol) {
        self.apiProvider = apiProvider
        self.securaDataProvider = secureDataProvider
    }
    
    //MARK: - Public functions -
    func onViewAppear() {
        viewState?(.loading(true))
        
        DispatchQueue.global().async {
            defer { self.viewState?(.loading(false)) }
            guard let token = self.securaDataProvider.getToken() else { return }
            self.apiProvider.getHeroes(by: nil, token: token) { heroes in
                self.onHeroesReponse(heroes)
            }
        }
    }
    
    func heroBy(index: Int) -> Hero? {
        if index >= 0 && index < heroesCount {
            heroes[index]
        }else {
            nil
        }
    }
    
    func heroDetailViewModel(index: Int) -> HeroDetailViewControllerDelegate? {
        guard let selectedHero = heroBy(index: index) else { return nil }
        
        return HeroDetailViewModel(
            hero: selectedHero,
            apiProvider: apiProvider,
            secureDataProvider: securaDataProvider)
    }
    
    // MARK: - Private functions -
    private func onHeroesReponse(_ heroes: Heroes) {
        DispatchQueue.main.async {
            // Update Core Data
            let managedObjectContext = CoreDataStack.shared.persistentContainer.viewContext
            heroes.forEach { $0.toManagedObject(in: managedObjectContext) }
            try? managedObjectContext.save()

            self.heroes = heroes
            self.viewState?(.loading(false))
            self.viewState?(.updateData)
        }
    }
}
