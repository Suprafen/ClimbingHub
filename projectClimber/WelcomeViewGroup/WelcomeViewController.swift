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
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.text = "You can extend your strength in the good looking application. Here we go!"
        
        return label
    }()
    
    let reasonNumberOne: NotationView = {
        let notation = NotationView(frame: CGRect(x: 0, y: 0, width: 0, height: 0),
                                    titleText: "Simple",
                                    descriptionText: "This application has pretty simple and intuitive design. So you’ll be in a familiar environment. ", image: UIImage(systemName: "rectangle.grid.1x2")!)
        notation.translatesAutoresizingMaskIntoConstraints = false
        
        return notation
    }()
    
    let reasonNumberTwo: NotationView = {
        let notation = NotationView(frame: CGRect(x: 0, y: 0, width: 0, height: 0),
                                    titleText: "Flexible",
                                    descriptionText: "Even though you can use default mode with no goal for a workout, the application gives you an opportunity to create your own.", image: UIImage(systemName: "paintbrush")!)
        notation.translatesAutoresizingMaskIntoConstraints = false
        
        return notation
    }()
    
    let reasonNumberThree: NotationView = {
        let notation = NotationView(frame: CGRect(x: 0, y: 0, width: 0, height: 0),
                                    titleText: "Syncing",
                                    descriptionText: "You can use our app as an anonymous. But keep in mind that all workouts you’re going to perform will be saved directly on your iPhone. But you can create an account and your data will be saved even after application has been deelted.", image: UIImage(systemName: "arrow.triangle.2.circlepath")!)
        notation.translatesAutoresizingMaskIntoConstraints = false
        
        return notation
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
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setConstraints()
    }
    
    //MARK: Helper Methods
    
    func setConstraints() {
        
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 30),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            reasonNumberOne.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            reasonNumberOne.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            reasonNumberOne.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            reasonNumberTwo.topAnchor.constraint(equalTo: reasonNumberOne.bottomAnchor, constant: 30),
            reasonNumberTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            reasonNumberTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            reasonNumberThree.topAnchor.constraint(equalTo: reasonNumberTwo.bottomAnchor, constant: 30),
            reasonNumberThree.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            reasonNumberThree.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            buttonStack.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -20),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    func configureView() {
        view.backgroundColor = .white
//        self.navigationItem.title = "Welcome to ClimbingHub"
        view.addSubview(welcomeLabel)
        view.addSubview(reasonNumberOne)
        view.addSubview(reasonNumberTwo)
        view.addSubview(reasonNumberThree)
        
        buttonStack.addArrangedSubview(getStartedButton)
        buttonStack.addArrangedSubview(alreadyHaveButton)
        buttonStack.addArrangedSubview(anonymousButton)
        
        view.addSubview(buttonStack)
        
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: Selectors
    // Different selectors for different buttons, which moves us to different views
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
        // It's a temporary function just for making sure that when we open local realm
        // We don't have logged in users.
        // When app closed, user is not loged out, meanwhile app doesn't save the state of logged in user.
        // So after restart we already logged in, but we can't get access to the workouts through sync realm,
        // however we can go to local realm and we'll appear as logged in user, which is unlikely behavior.
        // TODO: Make app save the state of logged in user
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
    // TODO: Make this func static, because it's already appeared third times
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
