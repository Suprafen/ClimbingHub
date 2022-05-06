//
//  WelcomeViewController.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 28.04.22.
//

import UIKit
import RealmSwift

class NewAccountViewController: UIViewController {
    let createAccountButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Create Account"
        config.buttonSize = .large
        
        let button = UIButton(configuration: config)
        button.addTarget(nil, action: #selector(createAccountTapped), for: .touchUpInside)
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
        label.text = "If you create an account you're agree with our privacy policy."
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        emailField.rightView = activityIndicator
        emailField.rightViewMode = .always
        container.addArrangedSubview(nameField)
        container.addArrangedSubview(emailField)
        container.addArrangedSubview(passwordField)

        view.addSubview(container)
        view.addSubview(createAccountButton)
        view.addSubview(privacyPolicyLabel)
        setConstraints()
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
            privacyPolicyLabel.bottomAnchor.constraint(equalTo: createAccountButton.topAnchor, constant: -20),
            
            createAccountButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            createAccountButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            createAccountButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -20)
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
        createAccountButton.isEnabled = !loading
        navigationItem.leftBarButtonItem?.isEnabled = !loading
    }
    
    //MARK: Selectors
    @objc func login() {
        print("Sign In")
        setLoading(true)
                   
        app.login(credentials: Credentials.emailPassword(email: emailField.text!, password: passwordField.text!)) { [weak self](result) in
            DispatchQueue.main.async {
                self!.setLoading(false)
                switch result {
                case .failure(let error):
                    self!.presentAlertController(with: error.localizedDescription.capitalized)
                    print("\(error.localizedDescription)")
                case .success(let user):
                    
                    self!.setLoading(true)
                    
                    let userConfiguration = user.configuration(partitionValue: "user=\(user.id)")
                    let workoutConfiguration = user.configuration(partitionValue: user.id)

                    Realm.asyncOpen(configuration: userConfiguration) { [weak self](result) in
                        DispatchQueue.main.async {
                            self!.setLoading(false)
                            switch result {
                            case .failure(let error):
                                self!.presentAlertController(with: error.localizedDescription.capitalized)
                                print("\(error.localizedDescription)")
                            case .success:
                                let viewtoShow = TabBarController(userRealmConfiguration: userConfiguration, workoutRealmConfiguration: workoutConfiguration)
                                viewtoShow.modalPresentationStyle = .fullScreen
                                
                                self!.present(viewtoShow, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func createAccountTapped() {
        setLoading(true)
        
        app.emailPasswordAuth.registerUser(email: emailField.text!, password: passwordField.text!) { [weak self](error) in
            DispatchQueue.main.async {
                self!.setLoading(false)
                guard error == nil else {
                    self!.presentAlertController(with: error!.localizedDescription.capitalized)
                    print("Error: \(error!.localizedDescription)")
                    
                    return
                }
                
                let user = app.currentUser!
                var workoutConfiguration = user.configuration(partitionValue: user.id)
                workoutConfiguration.objectTypes = [Workout.self, User.self]
                
                let localConfig = self!.localRealmConfig()
                // Open realm with this config
                let localRealm = try! Realm(configuration: localConfig)
                // Try to write a copy to sync realm config
                
                do {
                    try localRealm.writeCopy(configuration: workoutConfiguration)
                } catch {
                    self!.presentAlertController(with: error.localizedDescription.capitalized)
                    print("ERROR WE COULDN'T COPY REALM. FUCK THIS SHIT!: \(error.localizedDescription)")
                }
                localRealm.invalidate()
                
                do {
                   let _ = try Realm.deleteFiles(for: localConfig)
                } catch {
                    self!.presentAlertController(with: error.localizedDescription.uppercased())
                    print("\(error.localizedDescription)")
                }
                
                self?.setLoading(true)
                
                // Create new user config
                // And a user to save to the realm, with personal data, such as email and name
                let userConfig = user.configuration(partitionValue: "user=\(user.id)")
                let newUser = User(email: self!.emailField.text!, userID: "user=\(user.id)", name: self!.nameField.text!)
                
                Realm.asyncOpen(configuration: userConfig) { [weak self](result) in
                    DispatchQueue.main.async {
                        self!.setLoading(false)
                        switch result {
                        case .failure(let error):
                            self!.presentAlertController(with: error.localizedDescription.capitalized)
                            print("\(error.localizedDescription)")
                        case .success(let realm):
                            
                            try! realm.write {
                                realm.add(newUser)
                            }
                        }
                    }
                }
                self!.login()
            }
        }
        print("Sign Up")
    }
}
