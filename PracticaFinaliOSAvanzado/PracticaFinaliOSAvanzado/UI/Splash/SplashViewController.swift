//
//  SplashViewController.swift
//  PracticaFinaliOSAvanzado
//
//  Created by Sergio Reina Montes on 06/01/2024.
//

import UIKit

//MARK: - PROTOCOL -
protocol SplashViewControllerDelegate {
    var viewState: ((SplashViewState) -> Void)? { get set }
    var loginViewModel: LoginViewControllerDelegate { get }
    var heroesViewModel: HeroesViewControllerDelegate { get }
    
    func onViewAppear()
}

enum SplashViewState {
    case loading(_ isLoading: Bool)
    case navigateToLogin
    case navigateToHeroes
}

class SplashViewController: UIViewController {
    
    //@IBOutlets
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var viewModel: SplashViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setObservers()
        viewModel?.onViewAppear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "Splash_To_Login":
            guard let loginViewController = segue.destination as? LoginViewController else { return }
            loginViewController.viewModel = viewModel?.loginViewModel
            
        case "Splash_To_Heroes":
            guard let heroesViewController = segue.destination as? HeroesViewController else { return }
            heroesViewController.viewModel = viewModel?.heroesViewModel
            
            
        default:
            break
        }
    }
    
    private func setObservers() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .loading(let isLoading):
                    self?.loading.isHidden = !isLoading
                case .navigateToLogin:
                    self?.performSegue(withIdentifier: "Splash_To_Login", sender: nil)
                case .navigateToHeroes:
                    self?.performSegue(withIdentifier: "Splash_To_Heroes", sender: nil)
                }
            }
        }
    }
}
