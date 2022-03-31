//
//  GoalPickerViewController.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 31.03.22.
//

import UIKit

class GoalPickerViewController: UIViewController {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 40, weight: .semibold)
        label.text = "Goal Type"
        
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.numberOfLines = 2
        label.textColor = .systemGray2
        label.text = "Select goal type for your next workout."
        
        return label
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = 15
        
        return stack
    }()
    
    let openGoalButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(systemName: "infinity")
        configuration.imagePlacement = .top
//        configuration.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)
        configuration.imagePadding = 10
        configuration.title = "Open"
        configuration.baseBackgroundColor = .systemBlue.withAlphaComponent(0.6)
        configuration.baseForegroundColor = .systemBlue
        configuration.buttonSize = .large
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(nil, action: #selector(openGoalButtonTapped), for: .touchUpInside)
            
        return button
    }()
    
    let customGoalButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(systemName: "wrench")
        configuration.imagePlacement = .top
        configuration.imagePadding = 10
        configuration.title = "Custom"
        configuration.baseBackgroundColor = UIColor(rgb: 0xEC6A5E)
        configuration.baseForegroundColor = UIColor(rgb: 0x8C1A10)
        configuration.buttonSize = .large
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(nil, action: #selector(customGoalButtonTapped), for: .touchUpInside)
            
        return button
    }()
    
    let timeGoalButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(systemName: "timer")
        configuration.imagePlacement = .top
        configuration.imagePadding = 10
        configuration.title = "Time"
        configuration.baseBackgroundColor = UIColor(rgb: 0xF4BF4F)
        configuration.baseForegroundColor = UIColor(rgb: 0x8E5A1D)
        configuration.buttonSize = .large
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(nil, action: #selector(timeGoalButtonTapped), for: .touchUpInside)
            
        return button
    }()
    
    let openGoalCircle: UIView = {
        let circleDiameter: CGFloat = 10

        let view = UIView(frame: CGRect(x: 0, y: 0, width: circleDiameter, height: circleDiameter))
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = view.frame.height / 2
        view.clipsToBounds = true
        view.alpha = 0.2
        
        view.widthAnchor.constraint(equalToConstant: circleDiameter).isActive = true
        view.heightAnchor.constraint(equalToConstant: circleDiameter).isActive = true
        
        view.isHidden = true
        
        return view
    }()
    
    let customGoalCircle: UIView = {
        let circleDiameter: CGFloat = 10

        let view = UIView(frame: CGRect(x: 0, y: 0, width: circleDiameter, height: circleDiameter))
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = view.frame.height / 2
        view.clipsToBounds = true
        view.alpha = 0.2
        
        view.widthAnchor.constraint(equalToConstant: circleDiameter).isActive = true
        view.heightAnchor.constraint(equalToConstant: circleDiameter).isActive = true
        
        view.isHidden = true
        
        return view
    }()
    
    let timeGoalCircle: UIView = {
        let circleDiameter: CGFloat = 10

        let view = UIView(frame: CGRect(x: 0, y: 0, width: circleDiameter, height: circleDiameter))
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = view.frame.height / 2
        view.clipsToBounds = true
        view.alpha = 0.2
        
        view.widthAnchor.constraint(equalToConstant: circleDiameter).isActive = true
        view.heightAnchor.constraint(equalToConstant: circleDiameter).isActive = true
        
        view.isHidden = true
        
        return view
    }()
    
    let dismissButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "xmark.circle.fill")
        configuration.baseForegroundColor = .systemGray2
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(nil, action: #selector(dismissButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    var currentGoalType: WorkoutGoal!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
            
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 35),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subTitleLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            
            
            openGoalCircle.centerXAnchor.constraint(equalTo: openGoalButton.centerXAnchor),
            openGoalCircle.topAnchor.constraint(equalTo: openGoalButton.bottomAnchor, constant: 10),
            
            customGoalCircle.centerXAnchor.constraint(equalTo: customGoalButton.centerXAnchor),
            customGoalCircle.topAnchor.constraint(equalTo: customGoalButton.bottomAnchor, constant: 10),
            
            timeGoalCircle.centerXAnchor.constraint(equalTo: timeGoalButton.centerXAnchor),
            timeGoalCircle.topAnchor.constraint(equalTo: timeGoalButton.bottomAnchor, constant: 10),
        ])
    }
    
    //MARK: Helper methods
    func configureView() {
        self.view.backgroundColor = .white
        stackView.addArrangedSubview(openGoalButton)
        stackView.addArrangedSubview(customGoalButton)
        stackView.addArrangedSubview(timeGoalButton)
        
        self.view.addSubview(dismissButton)
        self.view.addSubview(titleLabel)
        self.view.addSubview(subTitleLabel)
        self.view.addSubview(openGoalCircle)
        self.view.addSubview(customGoalCircle)
        self.view.addSubview(timeGoalCircle)
        
        self.view.addSubview(stackView)
        
        self.dismissButton.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.openGoalCircle.translatesAutoresizingMaskIntoConstraints = false
        self.customGoalCircle.translatesAutoresizingMaskIntoConstraints = false
        self.timeGoalCircle.translatesAutoresizingMaskIntoConstraints = false
        
        setChosenTypeCircle()
    }
    
    func setChosenTypeCircle() {
        switch self.currentGoalType {
        case .openGoal:
            self.openGoalCircle.isHidden = false
        case .custom:
            self.customGoalCircle.isHidden = false
        case .time:
            self.timeGoalCircle.isHidden = false
        default:
            openGoalCircle.isHidden = false
            customGoalCircle.isHidden = false
            timeGoalCircle.isHidden = false
        }
    }
    
    //MARK: Selectors
    
    @objc func openGoalButtonTapped(sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                sender.transform = CGAffineTransform.identity
                self.openGoalCircle.isHidden = false
                self.customGoalCircle.isHidden = true
                self.timeGoalCircle.isHidden = true
            }
            
        }
    }
    
    @objc func customGoalButtonTapped(sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                sender.transform = CGAffineTransform.identity
                self.openGoalCircle.isHidden = true
                self.customGoalCircle.isHidden = false
                self.timeGoalCircle.isHidden = true
            }
            
        }
    }
    
    @objc func timeGoalButtonTapped(sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                sender.transform = CGAffineTransform.identity
                self.openGoalCircle.isHidden = true
                self.customGoalCircle.isHidden = true
                self.timeGoalCircle.isHidden = false
            }
            
        }
    }
    
    @objc func dismissButtonTapped() {
        self.dismiss(animated: true)
    }
}
