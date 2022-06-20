//
//  WelcomeViewController.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 2.05.22.
//

import UIKit
import RealmSwift
import Combine

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
        label.text = "ClimbingHub"
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textAlignment = .center
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
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
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
        config.title = "Sign In"
        
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
    
    enum SupplementaryKind {
        static let footer = "footer"
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, WelcomeReason>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, WelcomeReason>
    
    private let pagingInfoSubject = PassthroughSubject<PagingInfo, Never>()
    
    let reasons: [WelcomeReason] = [
        WelcomeReason(title: "Simple",
                      description: "This application has simple and intuitive design. So you’ll be in a familiar environment.", systemNameForImage: "rectangle.grid.2x2"),
        WelcomeReason(title: "Flexible",
                      description: "Even though you can use a default mode with no goal for a workout, the application gives you an opportunity to create your own.", systemNameForImage: "paintbrush"),
        WelcomeReason(title: "Sycing",
                      description: "We suggest creating an account to be sure that your data will be saved and available across devices you logged in.", systemNameForImage: "arrow.triangle.2.circlepath")]
    
    var dataSource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        configureView()
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
            
            cell.configure(with: item)
            return cell
        })
        
        dataSource.supplementaryViewProvider = {[unowned self] collectionView, kind, indexPath -> UICollectionReusableView? in
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryKind.footer, withReuseIdentifier: PagingSectionFooterView.reuseIdentifier, for: indexPath) as! PagingSectionFooterView
                let itemCount = 3
            
                footer.configure(with: itemCount)
                
                footer.subscribeTo(subject: pagingInfoSubject, for: indexPath.section)
                return footer
        }
        
        var snapshot = Snapshot()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(self.reasons, toSection: .main)
        
        dataSource.apply(snapshot)
    }
    
    func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            
            //Footer...
            let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20))
            let pagingFooterElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: SupplementaryKind.footer, alignment: .bottom)
            pagingFooterElement.contentInsets = NSDirectionalEdgeInsets(top: -45, leading: 0, bottom: 0, trailing: 0)
            
            //Main Section...
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
            let section = NSCollectionLayoutSection(group: group)
            
            section.boundarySupplementaryItems = [pagingFooterElement]
            section.orthogonalScrollingBehavior = .groupPagingCentered
            
            section.visibleItemsInvalidationHandler = {[weak self] (items, offset, env) -> Void in
                guard let self = self else { return }
                let page = round(offset.x / self.view.bounds.width)

                self.pagingInfoSubject.send(PagingInfo(sectionIndex: sectionIndex, currentPage: Int(page)))
            }
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
            
            containerView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: buttonStack.topAnchor, constant: -10),
            
            collectionView.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            collectionView.topAnchor.constraint(equalTo: containerView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            collectionView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStack.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -20)
        ])
    }

    func configureView() {
        view.backgroundColor = .white
        view.addSubview(welcomeLabel)
        containerView.addSubview(collectionView)
        view.addSubview(containerView)
        
        collectionView.register(WelcomeViewReasonCollectionViewCell.self, forCellWithReuseIdentifier: WelcomeViewReasonCollectionViewCell.reuseIdentifier)
        collectionView.register(PagingSectionFooterView.self, forSupplementaryViewOfKind: SupplementaryKind.footer, withReuseIdentifier: PagingSectionFooterView.reuseIdentifier)
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
        collectionView.isScrollEnabled = false
        buttonStack.addArrangedSubview(getStartedButton)
        buttonStack.addArrangedSubview(alreadyHaveButton)
        buttonStack.addArrangedSubview(anonymousButton)
        
        view.addSubview(buttonStack)
        
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: Selectors
    // Different selectors for different buttons, which move us to different views
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
