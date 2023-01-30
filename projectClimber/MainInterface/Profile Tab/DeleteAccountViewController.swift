//
//  DeleteAccountViewController.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 15.05.22.
//

import UIKit
import RealmSwift

class DeleteAccountViewController: UIViewController {

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    let baseView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.text = "Are you sure you want to delete your account?"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let firstNotation: NotationView = {
        let view = NotationView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), titleText: "You will lose your data", descriptionText: "All data that associated with this account will be eradicated. Your profile will no longer exist. Workouts which were perform on the local mode will last as long as the app is stored on your iPhone.", image: UIImage(systemName: "person.crop.circle")!)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let secondNotation: NotationView = {
        let view = NotationView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), titleText: "No sync", descriptionText: "After deletion you will not have opportunity to sync your workouts.", image: UIImage(systemName: "exclamationmark.arrow.triangle.2.circlepath")!)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let thirdNotation: NotationView = {
        let view = NotationView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), titleText: "We no longer collect your data", descriptionText: "All data you provided to us when you registered your account will be removed from our servers. It means we will not have access to it.", image: UIImage(systemName: "externaldrive")!)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let confirmButton: UIButton = {
        var configuration = UIButton.Configuration.gray()
        configuration.title = "Delete Account"
        configuration.baseForegroundColor = .systemRed
        configuration.buttonSize = .large
        
        let button = UIButton(configuration: configuration)
        button.addTarget(nil, action: #selector(confirmButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: margins.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            
            baseView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            baseView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor),
            baseView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            baseView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            baseView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            baseView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -20),

            firstNotation.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            firstNotation.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 20),
            firstNotation.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -20),

            secondNotation.topAnchor.constraint(equalTo: firstNotation.bottomAnchor, constant: 30),
            secondNotation.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 20),
            secondNotation.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -20),

            thirdNotation.topAnchor.constraint(equalTo: secondNotation.bottomAnchor, constant: 30),
            thirdNotation.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 20),
            thirdNotation.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -20),

            activityIndicator.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -15),
            
            confirmButton.topAnchor.constraint(greaterThanOrEqualTo: thirdNotation.bottomAnchor, constant: 30),
            confirmButton.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -20),
            confirmButton.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -20)
        ])
    }
    // MARK: Helper Methods
    func configureView() {
        self.view.backgroundColor = .white
        
        self.baseView.addSubview(titleLabel)
        self.baseView.addSubview(firstNotation)
        self.baseView.addSubview(secondNotation)
        self.baseView.addSubview(thirdNotation)
        self.baseView.addSubview(confirmButton)
        self.baseView.addSubview(activityIndicator)
        
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(baseView)
    }
    
    func presentAlertController(withMessage message: String, title: String, isTwoActions: Bool, cancelActionTitle: String = "OK", destructiveActionTitle: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if isTwoActions {
            let cancelAction = UIAlertAction(title: cancelActionTitle, style: .cancel)
            let destructiveAction = UIAlertAction(title: destructiveActionTitle, style: .destructive) { _ in
                self.setLoading(true)
                Task {
                    await self.deleteUser()
                }
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(destructiveAction)
        } else {
            let cancelAction = UIAlertAction(title: cancelActionTitle, style: .cancel) { _ in
                self.dismiss(animated: true)
            }
            
            alertController.addAction(cancelAction)
        }
        
        present(alertController, animated: true)
    }
    
    func setLoading(_ loading: Bool) {
        if loading {
            // TODO: Add activity indicator
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        
        confirmButton.isEnabled = !loading
        // Hide back button item
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func deleteUser() async {
        // Check whether user has been loged in
        guard let user = app.currentUser else { return }
        // Get user id
        let userID = user.id
        // Instantiate configurations base on user's data
        let workoutConfig = user.configuration(partitionValue: userID)
        let userConfig = user.configuration(partitionValue: "user=\(userID)")
        do {
            // Open realms
            let userRealm = try! await Realm( configuration: userConfig)
            let workoutRealm = try! await Realm( configuration: workoutConfig)
            // Delete all data from user realm
            try! userRealm.write {
                userRealm.deleteAll()
            }
            // Delete all data from user realm
            try! workoutRealm.write {
                workoutRealm.deleteAll()
            }
            // Try to delete the user
            try await user.delete()
            view.window?.windowScene?.userActivity = nil
            // Show the user that they data has been deleted
            setLoading(false)
            presentAlertController(withMessage: "You'll be logged out.", title: "Account Has Been Deleted.", isTwoActions: false)
            
        } catch {
            print(error.localizedDescription)
            return
        }
    }
    
    // MARK: Selectors
    @objc func confirmButtonTapped() {
        presentAlertController(withMessage: "This action cannot be undone! Are you sure you want to delete your account?", title: "Attention!", isTwoActions: true, cancelActionTitle: "No", destructiveActionTitle: "Yes")
    }
}
