//
//  WorkoutViewController.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 4.02.22.
//

import UIKit

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
    
    private let startButton: UIButton = {
        if #available(iOS 15, *) {
            
            var configuration = UIButton.Configuration.filled()
            configuration.image = UIImage(systemName: "play.fill")
            configuration.background.backgroundColor = .systemGreen
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
        
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200)
        ])
    }
    
    func configureView() {
        self.view.backgroundColor = .white
        
        startButton.translatesAutoresizingMaskIntoConstraints = false
//        stackView.addArrangedSubview(startButton)
        view.addSubview(startButton)
    }

    //MARK: Selectors
    
    @objc func startButtonTapped() {
        //define transition
        let fingerWorkoutViewController = FingerWorkoutViewController()
        fingerWorkoutViewController.modalPresentationStyle = .fullScreen
        
        present(fingerWorkoutViewController, animated: true)
    }
    
}
