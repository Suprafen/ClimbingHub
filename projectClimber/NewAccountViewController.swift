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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
          tapGesture.cancelsTouchesInView = true
          view.addGestureRecognizer(tapGesture)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard !nameField.text!.isEmpty else { return }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
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
        // Here's a local config I'm using for macking migration whether something has been changed
        // in realm's model
        // But only for Workout object
        // For example if I changed something in User object, I would face with unpredictable behavior.
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
    
    // Function that starts activity indicator and disable buttons
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
    @objc func createAccountTapped() {
        setLoading(true)
        
        // Execute registrating func
        app.emailPasswordAuth.registerUser(email: emailField.text!, password: passwordField.text!) { [weak self](error) in
            DispatchQueue.main.async {
                self!.setLoading(false)
                guard error == nil else {
                    self!.presentAlertController(with: error!.localizedDescription.capitalized)
                    print("Error: \(error!.localizedDescription)")
                    
                    return
                }
                // Bring a user to the view, where app's making clear
                // that email was sent, and the user must confirm registration.
                let viewToShow = EmailSentViewController(email: self!.emailField.text!)
                self?.navigationController?.pushViewController(viewToShow, animated: true)
            }
        }
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
