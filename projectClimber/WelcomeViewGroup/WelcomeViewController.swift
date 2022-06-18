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
        
    let buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        stack.spacing = 10
        
        return stack
    }()
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: UICollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
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
    
    enum Section: Hashable {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, WelcomeReason>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, WelcomeReason>
    
    let reasons: [WelcomeReason] = [
        WelcomeReason(title: "Simple",
                      description: "This application has pretty simple and intuitive design. So you’ll be in a familiar environment. "),
        WelcomeReason(title: "Flexible",
                  description: "Even though you can use default mode with no goal for a workout, the application gives you an opportunity to create your own."),
        WelcomeReason(title: "Sycing",
                      description: "You can use our app as an anonymous. But keep in mind that all workouts you’re going to perform will be saved directly on your iPhone. But you can create an account and your data will be saved even after application has been deelted.")]
    
    var dataSource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureDataSource()
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
    
    func configureDataSource() {
        dataSource = .init(collectionView: collectionView, cellProvider: {collectionView, indexPath, item -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WelcomeViewReasonCollectionViewCell.reuseIdentifier, for: indexPath) as! WelcomeViewReasonCollectionViewCell
            
            cell.backgroundColor = .blue
            return cell
        })
        
        var snapshot = Snapshot()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(self.reasons, toSection: .main)
        
        dataSource.apply(snapshot)
    }
    
    func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            
            return section
        }
        return layout
    }
    
    func setConstraints() {
        
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 30),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            collectionView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: buttonStack.topAnchor, constant: -20),
            
            buttonStack.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -20),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    func configureView() {
        view.backgroundColor = .white
        view.addSubview(welcomeLabel)
        view.addSubview(collectionView)
        
        collectionView.register(WelcomeViewReasonCollectionViewCell.self, forCellWithReuseIdentifier: WelcomeViewReasonCollectionViewCell.reuseIdentifier)
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
        
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
        // To ensure, that there's no logged user
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
