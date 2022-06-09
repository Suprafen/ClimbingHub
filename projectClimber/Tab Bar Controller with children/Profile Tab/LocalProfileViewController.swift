//
//  LocalProfileViewController.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 9.06.22.
//

import UIKit
import SafariServices

class LocalProfileViewController: UIViewController {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Local Environment"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let instructionLabel: UILabel = {
        let label = UILabel()
//        label.text = "You have not logged in, so it means that all workouts you're going to perform in this mode will be stored on your iPhone directly."
        label.text = "You haven't logged in. All data stored on your iPhone localy."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let secondInstructionLabel: UILabel = {
        let label = UILabel()
//        label.text = "If you delete app you'll lost your data. To prevent this we recomend you login or create a new account."
        label.text =  "If you delete the app you'll lost your data."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let backToMainViewButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In / Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .regular)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(nil, action: #selector(backToMainViewButtonTapped), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let privacyPolicyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Privacy Policy", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .regular)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(nil, action: #selector(privacyPolicyButtonTapped), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let supportLabel: UILabel = {
        let label = UILabel()
        label.text = "Contact us on the email if you encountered with any problem"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: UIFont.labelFontSize, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let supportEmailTextView: UITextView = {
        let textView = UITextView()
        textView.text = "climbinghub.help@gmail.com"
        textView.textAlignment = .center
        textView.font = UIFont.systemFont(ofSize: UIFont.labelFontSize, weight: .regular)
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.heightAnchor.constraint(equalToConstant: 44)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        setConstraints()
    }
    
    func configureView() {
        self.view.backgroundColor = .white
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Local Environment"
        
        self.view.addSubview(instructionLabel)
        self.view.addSubview(secondInstructionLabel)
        self.view.addSubview(supportLabel)
        self.view.addSubview(supportEmailTextView)
        self.view.addSubview(privacyPolicyButton)
        self.view.addSubview(backToMainViewButton)
    }
    
    func setConstraints() {
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            /// First paragraph of Instruction
//            instructionLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 30),
            instructionLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 30),
            instructionLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -30),
            instructionLabel.bottomAnchor.constraint(equalTo: secondInstructionLabel.topAnchor, constant: -20),
            /// Second paragraph of Instruction
//            secondInstructionLabel.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 20),
            secondInstructionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            secondInstructionLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 30),
            secondInstructionLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -30),
//            secondInstructionLabel.bottomAnchor.constraint(equalTo: supportLabel.topAnchor, constant: )
            /// Support label where we encourage user to email us if something bad happened
            supportLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 30),
            supportLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 30),
            supportLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -30),
            /// Email address textview. Textview because it's copyable
            supportEmailTextView.topAnchor.constraint(equalTo: supportLabel.bottomAnchor, constant: 10),
            supportEmailTextView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0),
            supportEmailTextView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0),
            /// Button to move to privacy policy page
//            privacyPolicyButton.topAnchor.constraint(equalTo: supportEmailTextView.bottomAnchor, constant: 40),
            privacyPolicyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            privacyPolicyButton.bottomAnchor.constraint(equalTo: backToMainViewButton.topAnchor, constant: -20),
            
            /// Pretty self-explanatory
//            backToMainViewButton.topAnchor.constraint(equalTo: privacyPolicyButton.bottomAnchor, constant: 20),
            backToMainViewButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0),
            backToMainViewButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0),
            backToMainViewButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -40)
        ])
    }

    @objc func backToMainViewButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc func privacyPolicyButtonTapped() {
        let privacyPolicyStringURL = "https://johny77.notion.site/ClimbingHub-Main-page-8882b7030b5645ba8cdfc9af7e6d6efa"
        if let url = URL(string: privacyPolicyStringURL) {
            let safariController = SFSafariViewController(url: url)
            present(safariController, animated: true)
        }
    }
}
