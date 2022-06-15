//
//  WelcomeViewController.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 28.04.22.
//

import UIKit
import RealmSwift
import SwiftUI
import SafariServices

class NewAccountViewController: UIViewController {
    
    let createAccountButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Create Account"
        config.buttonSize = .large
        
        let button = UIButton(configuration: config)
        button.addTarget(nil, action: #selector(createAccountTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        
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
        emailField.addTarget(nil, action: #selector(emailFieldChanged(_:)), for: .editingChanged)
        return emailField
    }()
    
    let repeatPasswordField: UITextField = {
        // Configure the username text input field.
        let repeatPasswordField = UITextField()
        repeatPasswordField.placeholder = "Repeat Password"
        repeatPasswordField.borderStyle = .roundedRect
        repeatPasswordField.isSecureTextEntry = true
        repeatPasswordField.addTarget(nil, action: #selector(passwordFieldChanged(_:)), for: .editingChanged)
        return repeatPasswordField
    }()
    
    let passwordField: UITextField = {
        //Configure the passwrod text input field
        let passwordField = UITextField()
        passwordField.placeholder = "Password"
        passwordField.borderStyle = .roundedRect
        passwordField.isSecureTextEntry = true
        passwordField.addTarget(nil, action: #selector(passwordFieldChanged(_:)), for: .editingChanged)
        
        return passwordField
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
    
    let privacyPolicyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Learn more...", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .regular)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(nil, action: #selector(privacyPolicyButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let attentionMessageView: AttentionMessageView = {
        let view = AttentionMessageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), .wrongPassword)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
          tapGesture.cancelsTouchesInView = true
          view.addGestureRecognizer(tapGesture)
        
        container.addArrangedSubview(emailField)
        container.addArrangedSubview(passwordField)
        container.addArrangedSubview(repeatPasswordField)
        
        view.addSubview(container)
        view.addSubview(createAccountButton)
        view.addSubview(attentionMessageView)
        view.addSubview(privacyPolicyLabel)
        view.addSubview(privacyPolicyButton)
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard !emailField.text!.isEmpty else { return }
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
                
            attentionMessageView.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 20),
            attentionMessageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            attentionMessageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            privacyPolicyLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            privacyPolicyLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            privacyPolicyLabel.bottomAnchor.constraint(equalTo: privacyPolicyButton.topAnchor, constant: -10),
            
            privacyPolicyButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            privacyPolicyButton.bottomAnchor.constraint(equalTo: createAccountButton.topAnchor, constant: -20),
            
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
    
    func updateUI(){
        if emailField.isEmail() && isPasswordsIdenticalInFields() {
            createAccountButton.isEnabled = true
        } else {
            createAccountButton.isEnabled = false
        }
    }
    
    func isPasswordsIdenticalInFields() -> Bool {
        // Bounding value to make sure that text field has a text
        // then we need to ensure that strings are not empty
        guard let password = passwordField.text, let repeatedPassword = repeatPasswordField.text,
                password == repeatedPassword,
                !password.isEmpty && !repeatedPassword.isEmpty else {
            // Check if passwords fields are empty
            // Because we don't need to show attention message when password fields are empty
            if let password = passwordField.text, let repeatedPassword = repeatPasswordField.text, password.isEmpty && repeatedPassword.isEmpty {
                attentionMessageView.isHidden = true
            } else {
                attentionMessageView.isHidden = false
            }
            return false
        }
        // Hide attention view
        attentionMessageView.isHidden = true
        return true
    }
    
    func setLoading(_ loading: Bool) {
        self.createAccountButton.configuration?.showsActivityIndicator = loading
        self.createAccountButton.configuration?.title = loading ? "Creating Account..." : "Create Account"
        
        createAccountButton.isEnabled = !loading
        emailField.isEnabled = !loading
        passwordField.isEnabled = !loading
        repeatPasswordField.isEnabled = !loading
        privacyPolicyButton.isEnabled = !loading
        self.navigationItem.setHidesBackButton(loading, animated: true)
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
    
    @objc func passwordFieldChanged(_ sender: UITextField) {
        updateUI()
    }
    
    @objc func emailFieldChanged(_ sender: UITextField) {
        updateUI()
    }
    
    @objc func privacyPolicyButtonTapped() {
        let privacyPolicyStringURL = "https://johny77.notion.site/ClimbingHub-Main-page-8882b7030b5645ba8cdfc9af7e6d6efa"
        if let url = URL(string: privacyPolicyStringURL) {
            let safariController = SFSafariViewController(url: url)
            present(safariController, animated: true)
        }
    }
}
