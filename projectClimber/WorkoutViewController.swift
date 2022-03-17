//
//  WorkoutViewController.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 4.02.22.
//

import UIKit
import AuthenticationServices

//class with HUGE start button

class WorkoutViewController: UIViewController {

    private let stackView:  UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 10
        
        return stackView
    }()
    
    private let firstTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Finger"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .white
        
        return label
    }()
    
    private let secondTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Workout"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .white
        
        return label
    }()
    
    private let overviewFingerWorkoutBackground: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "FingerWorkoutImage"))
        imageView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.backgroundColor = .systemBlue
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        
        
        return imageView
    }()
    
    private let startButton: UIButton = {
        if #available(iOS 15, *) {
            
            var configuration = UIButton.Configuration.filled()
            configuration.image = UIImage(systemName: "play.fill")
            configuration.background.backgroundColor = .systemBlue
            configuration.buttonSize = .large
        let button = UIButton(configuration: configuration, primaryAction: nil)

            button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
            

            return button
        } else {
            return UIButton()
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            
            
            overviewFingerWorkoutBackground.heightAnchor.constraint(equalTo: overviewFingerWorkoutBackground.widthAnchor, multiplier: 3/2),
            overviewFingerWorkoutBackground.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20),
            overviewFingerWorkoutBackground.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 5),
            overviewFingerWorkoutBackground.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -5),
            overviewFingerWorkoutBackground.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -20),
            
            firstTitleLabel.topAnchor.constraint(equalTo: overviewFingerWorkoutBackground.topAnchor, constant: 20),
            firstTitleLabel.leadingAnchor.constraint(equalTo: overviewFingerWorkoutBackground.leadingAnchor, constant: 20),
            
            secondTitleLabel.topAnchor.constraint(equalTo: firstTitleLabel.bottomAnchor, constant: 5),
            secondTitleLabel.leadingAnchor.constraint(equalTo: overviewFingerWorkoutBackground.leadingAnchor, constant: 20),
            
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: overviewFingerWorkoutBackground.bottomAnchor, constant: -20)
        ])
    }
    
    func configureView() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Workout"
        
        view.addSubview(overviewFingerWorkoutBackground)
        view.addSubview(startButton)
        view.addSubview(firstTitleLabel)
        view.addSubview(secondTitleLabel)
        
        startButton.translatesAutoresizingMaskIntoConstraints = false
        overviewFingerWorkoutBackground.translatesAutoresizingMaskIntoConstraints = false
        firstTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        secondTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        overviewFingerWorkoutBackground
    }

    //MARK: Selectors
    
    @objc func startButtonTapped() {
        //define transition
        let fingerWorkoutViewController = FingerWorkoutViewController()
        fingerWorkoutViewController.modalPresentationStyle = .fullScreen
        
        present(fingerWorkoutViewController, animated: true)
    }
}
