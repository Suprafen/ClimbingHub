//
//  SignInViewController.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 2.05.22.
//

import UIKit
import RealmSwift

class SignInViewController: UIViewController {
    
    let signInButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Sign In"
        config.buttonSize = .large
        
        let button = UIButton(configuration: config)
        button.addTarget(nil, action: #selector(signInButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let buttonContainer: UIStackView = {
        let container = UIStackView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.axis = .horizontal
        container.distribution = .equalSpacing
        container.alignment = .fill
        container.spacing = 16.0
        
        return container
    }()
    
    let container: UIStackView = {
        let container = UIStackView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.axis = .vertical
        container.alignment = .fill
        container.spacing = 16.0
        
        return container
    }()
    
    let emailField: UITextField = {
        // Configure the username text input field.
        let emailField = UITextField()
        emailField.placeholder = "Email"
        emailField.borderStyle = .roundedRect
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        
        return emailField
    }()
    
    let nameField: UITextField = {
        // Configure the username text input field.
        let nameField = UITextField()
        nameField.placeholder = "Name"
        nameField.borderStyle = .roundedRect
        nameField.autocapitalizationType = .none
        nameField.autocorrectionType = .no
        
        return nameField
    }()
    
    let passwordField: UITextField = {
        //Configure the passwrod text input field
        let passwordField = UITextField()
        passwordField.placeholder = "Password"
        passwordField.borderStyle = .roundedRect
        passwordField.isSecureTextEntry = true
        
        return passwordField
    }()
    
    let forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Forgot Password?", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .regular)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(nil, action: #selector(forgotPasswordButtonTapped), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        
        return activityIndicator
    }()
    
    let privacyPolicyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray2
        label.textAlignment = .center
        label.text = "If you sign in you're agree with our privacy policy."
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
          tapGesture.cancelsTouchesInView = true
          view.addGestureRecognizer(tapGesture)
        
        emailField.rightView = activityIndicator
        emailField.rightViewMode = .always
        container.addArrangedSubview(emailField)
        container.addArrangedSubview(passwordField)

        view.addSubview(container)
        view.addSubview(signInButton)
        view.addSubview(privacyPolicyLabel)
        view.addSubview(forgotPasswordButton)
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Remove everything from the password field
        passwordField.text?.removeAll()
    }
    //MARK: Helper methods
    func setConstraints() {
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            container.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -30),
            container.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            container.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
                
            privacyPolicyLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            privacyPolicyLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            privacyPolicyLabel.bottomAnchor.constraint(equalTo: signInButton.topAnchor, constant: -20),
            
            forgotPasswordButton.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 10),
            forgotPasswordButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            signInButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            signInButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            signInButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -20)
        ])
    }
    
    func localRealmConfig() -> Realm.Configuration {
        let localConfig = Realm.Configuration(schemaVersion: 3, migrationBlock: { migration, oldSchemaVersion in
            if oldSchemaVersion < 1 {
                migration.enumerateObjects(ofType: Workout.className()) { old, new in
                    new?["goalType"] = WorkoutGoal.openGoal
                }
            }
            if oldSchemaVersion < 2 {
                migration.enumerateObjects(ofType: Workout.className()) {old, new in
                    new?["_id"] = ObjectId.generate()
                }
            }
            if oldSchemaVersion < 3 {
                migration.enumerateObjects(ofType: Workout.className()) { old, new in
                    guard let id = app.currentUser?.id else {
                        // Here should be something different for ensure,
                        // That value userID will be the same as Sync Realm, but I have no idea
                        // How to achieve this
                        new?["userID"] = old?["_id"]
                        return
                    }
                    new?["userID"] = id
                }
            }
        }, objectTypes: [Workout.self] )
        
        return localConfig
    }
    
    func presentAlertController(with message: String) {
        let alertController = UIAlertController(title: "Error Occured", message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    func setLoading(_ loading: Bool) {
        if loading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        
        emailField.isEnabled = !loading
        passwordField.isEnabled = !loading
//        signInButton.isEnabled = !loading
        signInButton.isEnabled = !loading
    }
    
    //MARK: Selectors
    
    @objc func signInButtonTapped() {
        print("Sign In")
        setLoading(true)
                   
        
        // Execute method for logining user
        app.login(credentials: Credentials.emailPassword(email: emailField.text!, password: passwordField.text!)) { [weak self](result) in
            DispatchQueue.main.async {
                self!.setLoading(false)
                switch result {
                case .failure(let error):
                    self!.presentAlertController(with: error.localizedDescription.capitalized)
                    print("\(error.localizedDescription)")
                case .success(let user):
                    
                    self!.setLoading(true)
                    
                    // Define realm configurations based on the user's id
                    // Set different partition values for user and workout configs
                    let userConfiguration = user.configuration(partitionValue: "user=\(user.id)")
                    let workoutConfiguration = user.configuration(partitionValue: user.id)

                    // Async open a realm, just for making sure that the realm's downloaded everything
                    Realm.asyncOpen(configuration: userConfiguration) { [weak self](result) in
                        DispatchQueue.main.async {
                            self!.setLoading(false)
                            switch result {
                            case .failure(let error):
                                self!.presentAlertController(with: error.localizedDescription.capitalized)
                                print("\(error.localizedDescription)")
                            case .success:
                                // Another async open, but now this one for workouts
                                Realm.asyncOpen(configuration: workoutConfiguration) {[weak self](result) in
                                    DispatchQueue.main.async {
                                        switch result {
                                        case .failure(let error):
                                            self!.presentAlertController(with: error.localizedDescription)
                                        case .success:
                                            // Present tab bar
                                            let viewtoShow = TabBarController(userRealmConfiguration: userConfiguration, workoutRealmConfiguration: workoutConfiguration, email: self!.emailField.text!)
                                            viewtoShow.modalPresentationStyle = .fullScreen
                                            
                                            self!.present(viewtoShow, animated: true)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func forgotPasswordButtonTapped() {
        let controllerToPush = ForgotPasswordViewController()
        controllerToPush.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(controllerToPush, animated: true)
    }
}

// MARK: Keyboard dismissing
extension SignInViewController {
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
