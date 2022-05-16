//
//  DeleteAccountViewController.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 15.05.22.
//

import UIKit

// - TODO: - Create an independent view that replaces stackLabel.

class DeleteAccountViewController: UIViewController {

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    let baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.isUserInteractionEnabled = true
        
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
    
    // First notation
    let firstLabelStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    let firstSubTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.text = "You will lose your data"
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let firstDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        label.text = "Here goes text that makes clear user is going to lose their data and so on. "
        label.textAlignment = .left
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // Second notation
    
    let secondLabelStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    let secondSubTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.text = "You will lose your data"
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let secondDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        label.text = "Here goes text that makes clear user is going to lose their data and so on."
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // Third notation
    
    let thirdLabelStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    let thirdSubTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.text = "You will lose your data"
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let thirdDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        label.text = "Here goes text that makes clear user is going to lose their data and so on."
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let confirmButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Delete my account"
        configuration.baseBackgroundColor = .systemRed
        configuration.buttonSize = .large
        
        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
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
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            baseView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            baseView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor),
            baseView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            baseView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            baseView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            baseView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -20),

            firstLabelStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            firstLabelStack.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 20),
            firstLabelStack.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -20),

            secondLabelStack.topAnchor.constraint(equalTo: firstLabelStack.bottomAnchor, constant: 30),
            secondLabelStack.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 20),
            secondLabelStack.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -20),

            thirdLabelStack.topAnchor.constraint(equalTo: secondLabelStack.bottomAnchor, constant: 30),
            thirdLabelStack.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 20),
            thirdLabelStack.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -20),

            confirmButton.topAnchor.constraint(greaterThanOrEqualTo: thirdLabelStack.bottomAnchor, constant: 30),
            confirmButton.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -20),
            confirmButton.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -20)
        ])
    }
    
    func configureView() {
        self.view.backgroundColor = .white
        
        self.firstLabelStack.addArrangedSubview(firstSubTitleLabel)
        self.firstLabelStack.addArrangedSubview(firstDescriptionLabel)
        
        self.secondLabelStack.addArrangedSubview(secondSubTitleLabel)
        self.secondLabelStack.addArrangedSubview(secondDescriptionLabel)
        
        self.thirdLabelStack.addArrangedSubview(thirdSubTitleLabel)
        self.thirdLabelStack.addArrangedSubview(thirdDescriptionLabel)
        
        self.baseView.addSubview(titleLabel)
        self.baseView.addSubview(firstLabelStack)
        self.baseView.addSubview(secondLabelStack)
        self.baseView.addSubview(thirdLabelStack)
        self.baseView.addSubview(confirmButton)
        
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(baseView)
    }
    
    @objc func confirmButtonTapped() {
        print("tapped")
        //TODO: Add functionality to delete a user
    }
}
