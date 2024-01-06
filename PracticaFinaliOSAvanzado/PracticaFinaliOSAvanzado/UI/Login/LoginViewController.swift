//
//  LoginViewController.swift
//  PracticaFinaliOSAvanzado
//
//  Created by Sergio Reina Montes on 02/01/2024.
//

import UIKit

//MARK: PROTOCOL
protocol LoginViewControllerDelegate {
    var viewState: ((LoginViewState) -> Void)? { get set }
    var heroesViewModel: HeroesViewControllerDelegate { get }
    func onLoginPressed(email: String?, password: String?)
}

enum LoginViewState {
    case loading(_ isLoading: Bool)
    case showErrorEmail(_ error: String?)
    case showErrorPassword(_ error: String?)
    case navigateToNext
}


class LoginViewController: UIViewController {
    
    //IBOutlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailFieldError: UILabel!
    @IBOutlet weak var passwordFieldError: UILabel!
    @IBOutlet weak var loadingView: UIView!
    
    //@IBAction
    @IBAction func onLoginPressed() {
        //Obtener el email y password introducidos por el user y enviarlo al servicio API de Login
        
        viewModel?.onLoginPressed(
            email: emailField.text,
            password: passwordField.text)
    }
    
    //MARK: - Public Properties -
    var viewModel: LoginViewControllerDelegate?
    
    private enum FieldType: Int {
        case email = 0
        case password
    }
    
    //MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setObservers()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "Login_To_Heroes",
              let heroesViewController = segue.destination as? HeroesViewController else {
            return
        }
        heroesViewController.viewModel = viewModel?.heroesViewModel
    }
    
    private func initViews() {
        emailField.delegate = self
        emailField.tag = FieldType.email.rawValue
        passwordField.delegate = self
        passwordField.tag = FieldType.password.rawValue
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setObservers() {
        //Importante: Ponemos [weak self] para poder destruir espacio de memoria y no crear un ciclo de memoria
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .loading(let isLoading):
                    self?.loadingView.isHidden = !isLoading
                    
                case .showErrorEmail(let error):
                    self?.emailFieldError.text = error
                    self?.emailFieldError.isHidden = (error == nil || error?.isEmpty == true)
                    
                case .showErrorPassword(let error):
                    self?.passwordFieldError.text = error
                    self?.passwordFieldError.isHidden = (error == nil || error?.isEmpty == true)
                    
                case .navigateToNext:
                    //Navegar a la siguiente vista
                    self?.performSegue(withIdentifier: "Login_To_Heroes",
                                       sender: nil)
                }
            }
        }
    }
}

//MARK: - EXTENSION -
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch FieldType(rawValue: textField.tag) {
        case .email:
            emailFieldError.isHidden = true
            
        case .password:
            passwordFieldError.isHidden = true
            
        default: break
        }
    }
}
