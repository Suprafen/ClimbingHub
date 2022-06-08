//
//  EmailSentViewController.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 22.05.22.
//

import UIKit

class EmailSentViewController: UIViewController {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Email has been sent"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let label: UILabel = {
        let label  = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let returnToLogInScreenButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Return To Login Screen"
        config.buttonSize = .large
        
        let button = UIButton(configuration: config)
        button.addTarget(nil, action: #selector(returnToLogInScreenButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    init(email: String) {
        label.text =  "Thank you. We have sent you a letter to provided email. Please click on the link in the email to confirm a registration."
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        setConstraints()
    }
    
    // MARK: Helper methods
    func setConstraints() {
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            returnToLogInScreenButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            returnToLogInScreenButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            returnToLogInScreenButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -20)
        ])
    }
    
    func configureView() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(label)
        view.addSubview(returnToLogInScreenButton)
    }
    
    // MARK: Selectors
    @objc func returnToLogInScreenButtonTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
