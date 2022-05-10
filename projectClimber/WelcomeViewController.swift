//
//  WelcomeViewController.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 2.05.22.
//

import UIKit
import RealmSwift

class WelcomeViewController: UIViewController {

    let labelStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        stack.spacing = 15
        
        return stack
    }()
    
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.text = "Welcome to ClimbingHub"
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.text = "You can extend your strength in the good looking application. Here we go!"
        
        return label
    }()
    
    let reasonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    let reason1Label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.text = "Reason to create an account"
        
        return label
    }()
    
    let reason2Label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.text = "Reason to create an account"
        
        return label
    }()
    
    let reason3Label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.text = "Reason to create an account"
        
        return label
    }()
    
    let buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        stack.spacing = 10
        
        return stack
    }()
    
    let getStartedButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.title = "Get started"
        
        let button = UIButton(configuration: config)
        button.addTarget(nil, action: #selector(getStartedButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    let alreadyHaveButton: UIButton = {
        var config = UIButton.Configuration.gray()
        config.buttonSize = .large
        config.title = "I already have an account"
        
        let button = UIButton(configuration: config)
        button.addTarget(nil, action: #selector(alreadyHaveButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    let anonymousButton: UIButton = {
        var config = UIButton.Configuration.gray()
        config.buttonSize = .large
        config.title = "I prefer to remain anonymous"
        
        let button = UIButton(configuration: config)
        button.addTarget(nil, action: #selector(anonymousButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setConstraints()
    }
    
    //MARK: Helper Methods
    
    func setConstraints() {
        
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            labelStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            labelStack.bottomAnchor.constraint(equalTo: reasonsStack.topAnchor, constant: -30),
            
            reasonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            reasonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            reasonsStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            buttonStack.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -20),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    func configureView() {
        view.backgroundColor = .white
        labelStack.addArrangedSubview(welcomeLabel)
        labelStack.addArrangedSubview(descriptionLabel)
        
        view.addSubview(labelStack)
        
        reasonsStack.addArrangedSubview(reason1Label)
        reasonsStack.addArrangedSubview(reason2Label)
        reasonsStack.addArrangedSubview(reason3Label)
        
        view.addSubview(reasonsStack)
        
        buttonStack.addArrangedSubview(getStartedButton)
        buttonStack.addArrangedSubview(alreadyHaveButton)
        buttonStack.addArrangedSubview(anonymousButton)
        
        view.addSubview(buttonStack)
        
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: Selectors
    @objc func getStartedButtonTapped() {
        let viewToShow = NewAccountViewController()
        navigationController?.pushViewController(viewToShow, animated: true)
    }
    
    @objc func alreadyHaveButtonTapped() {
        let viewToShow = SignInViewController()
        navigationController?.pushViewController(viewToShow, animated: true)
    }
    
    @objc func anonymousButtonTapped() {
        let userRealm = Realm.Configuration(schemaVersion: 3)
        if app.currentUser != nil {
            app.currentUser!.logOut { (_) in
            }
        }
        
        let viewToShow = TabBarController(userRealmConfiguration: userRealm, workoutRealmConfiguration: localRealmConfig)
        viewToShow.modalPresentationStyle = .fullScreen
        self.present(viewToShow, animated: true)
    }
}

extension WelcomeViewController {
    var localRealmConfig: Realm.Configuration {
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
}
