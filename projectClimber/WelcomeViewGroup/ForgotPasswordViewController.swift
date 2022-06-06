//
//  ForgotPasswordViewController.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 5.06.22.
//

// TODO: - Add an email validation to the text field
// TODO: Add a check for confirm button. If email is not correct button is not active
 
import UIKit

class ForgotPasswordViewController: UIViewController {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter Your Email"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "On a given email wiil be sent a latter with an instruction that helps you to change your password."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let emailField: UITextField = {
        // Configure the username text input field.
        let emailField = UITextField()
        emailField.placeholder = "Email"
        emailField.borderStyle = .roundedRect
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.keyboardType = .emailAddress
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailField.addTarget(nil, action: #selector(emailFieldChanged(_:)), for: .editingChanged)
        
        return emailField
    }()
    
    let confirmButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Confirm"
        config.buttonSize = .large
        
        let button = UIButton(configuration: config)
        button.addTarget(nil, action: #selector(confirmButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
          tapGesture.cancelsTouchesInView = true
          view.addGestureRecognizer(tapGesture)
        
        configureView()
        setConstraints()
    }
    

    // MARK: Helper methods
    
    func configureView() {
        self.view.backgroundColor = .white
        
        self.confirmButton.isEnabled = false
        
        self.view.addSubview(emailField)
        self.view.addSubview(confirmButton)
        self.view.addSubview(titleLabel)
        self.view.addSubview(instructionLabel)
    }
    
    func setConstraints() {
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            instructionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            instructionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            instructionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            
            emailField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -30),
            emailField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            emailField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            confirmButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            confirmButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -20)
        ])
    }
    
    func presentAlertController(with message: String) {
        let alertController = UIAlertController(title: "Email sent!", message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    func getConsent() async throws{
        let client = app.emailPasswordAuth
        // Send email to a user.
        // The User must confirm that they are owner of this email
        _ = client.sendResetPasswordEmail(email: self.emailField.text!)
    }
    
    // MARK: Selectors
    @objc func confirmButtonTapped() {
        Task {
            do {
                try await getConsent()
                presentAlertController(with: "We've sent you a confirmation email. Check your inbox.")
            }
            catch {
                presentAlertController(with: error.localizedDescription)
            }
        }
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func emailFieldChanged(_ sender: UITextField) {
        if sender.isEmail() != true {
            confirmButton.isEnabled = false
        } else {
            confirmButton.isEnabled = true
        }
    }
}
