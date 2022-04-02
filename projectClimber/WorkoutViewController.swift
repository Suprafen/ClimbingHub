//
//  WorkoutViewController.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 4.02.22.
//

import UIKit

//class with HUGE start button

class WorkoutViewController: UIViewController {

    private let changeGoalTypeButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "ellipsis.circle")
        configuration.baseForegroundColor = .white
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(nil, action: #selector(changeGoalTypeButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
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
    
    private let workoutDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.textColor = .white
        label.numberOfLines = 2
        label.text = "Open goal finger workout helps you to develop your grip strength."
        
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
            configuration.attributedTitle = "Start"
            configuration.imagePadding = 10
            configuration.imagePlacement = .trailing
            configuration.baseBackgroundColor = .systemBlue.withAlphaComponent(0.8)
            configuration.buttonSize = .large
        let button = UIButton(configuration: configuration, primaryAction: nil)

            button.addTarget(nil, action: #selector(startButtonTapped), for: .touchUpInside)
            

            return button
        } else {
            return UIButton()
        }
    }()
  
    private let settingsWorkoutButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .systemGray5
        configuration.baseForegroundColor = .systemGray
        configuration.buttonSize = .large
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(nil, action: #selector(settingsWorkoutButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        
        return button
    }()
    
    var workoutParameters: WorkoutParamters = WorkoutParamters()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            
            
//            overviewFingerWorkoutBackground.heightAnchor.constraint(equalTo: overviewFingerWorkoutBackground.widthAnchor, multiplier: 3/2),
            overviewFingerWorkoutBackground.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0),
            overviewFingerWorkoutBackground.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20),
            overviewFingerWorkoutBackground.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -20),
            
            changeGoalTypeButton.topAnchor.constraint(equalTo: overviewFingerWorkoutBackground.topAnchor, constant: 20),
            changeGoalTypeButton.trailingAnchor.constraint(equalTo: overviewFingerWorkoutBackground.trailingAnchor, constant: -10),
            
            firstTitleLabel.topAnchor.constraint(equalTo: overviewFingerWorkoutBackground.topAnchor, constant: 20),
            firstTitleLabel.leadingAnchor.constraint(equalTo: overviewFingerWorkoutBackground.leadingAnchor, constant: 20),
            
            secondTitleLabel.topAnchor.constraint(equalTo: firstTitleLabel.bottomAnchor, constant: 5),
            secondTitleLabel.leadingAnchor.constraint(equalTo: overviewFingerWorkoutBackground.leadingAnchor, constant: 20),
            
            workoutDescriptionLabel.topAnchor.constraint(equalTo: secondTitleLabel.bottomAnchor, constant: 15),
            workoutDescriptionLabel.leadingAnchor.constraint(equalTo: overviewFingerWorkoutBackground.leadingAnchor, constant: 20),
            workoutDescriptionLabel.trailingAnchor.constraint(equalTo: overviewFingerWorkoutBackground.trailingAnchor, constant: -20),
            
            settingsWorkoutButton.topAnchor.constraint(equalTo: overviewFingerWorkoutBackground.bottomAnchor, constant: 15),
            settingsWorkoutButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20),
            settingsWorkoutButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -20),
//            settingsWorkoutButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -20)
            
            startButton.topAnchor.constraint(equalTo: settingsWorkoutButton.bottomAnchor, constant: 15),
            startButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -20),
            startButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -15)
        ])
    }
    
    //MARK: Helper methods
    func setGoal() {
        workoutParameters.workoutGoal = .openGoal
    }
    
    func configureView() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Workout"
        
        view.addSubview(overviewFingerWorkoutBackground)
        view.addSubview(changeGoalTypeButton)
        view.addSubview(settingsWorkoutButton)
        view.addSubview(startButton)
        view.addSubview(firstTitleLabel)
        view.addSubview(secondTitleLabel)
        view.addSubview(workoutDescriptionLabel)
        
        changeGoalTypeButton.translatesAutoresizingMaskIntoConstraints = false
        settingsWorkoutButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false
        overviewFingerWorkoutBackground.translatesAutoresizingMaskIntoConstraints = false
        firstTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        secondTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        workoutDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        updateUI()
    }

    func changeConfigurationForStartButton(baseBackgroundColor: UIColor) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(systemName: "play.fill")
        configuration.attributedTitle = "Start"
        configuration.imagePadding = 10
        configuration.imagePlacement = .trailing
        configuration.baseBackgroundColor = baseBackgroundColor
        configuration.buttonSize = .large
        
        return configuration
    }
    
    func changeConfigurationForSettingsWorkoutButton() {
        var configuration = UIButton.Configuration.filled()
        configuration.imagePadding = 10
        configuration.baseBackgroundColor = .systemGray5
        configuration.baseForegroundColor = .systemGray
        configuration.buttonSize = .large
        
        let parameters = self.workoutParameters
        
        switch parameters.workoutGoal {
        case .openGoal:
            configuration.attributedTitle = "Unavailable"
            settingsWorkoutButton.isEnabled = false
        case .custom:
            // Need to calculate duration according to duration of each split and rest and their quantity
            let duration = (parameters.durationOfEachRest * parameters.numberOfRests)
            + (parameters.durationOfEachSplit * parameters.numberOfSplits)
            configuration.title = "Splits: \(parameters.numberOfSplits)  Duration: \(String.makeTimeString(seconds: duration, withLetterDescription: true))"
            settingsWorkoutButton.isEnabled = true
        case .time:
            configuration.title = "Duration: \(String.makeTimeString(seconds: parameters.durationForTimeGoal, withLetterDescription: true))"
            settingsWorkoutButton.isEnabled = true
        }
        self.settingsWorkoutButton.configuration = configuration
    }
    
    func updateUI() {
        switch self.workoutParameters.workoutGoal {
        case .openGoal:
            self.workoutDescriptionLabel.text  = "Open goal finger workout helps you to develop your grip strength."
            self.startButton.configuration = changeConfigurationForStartButton(baseBackgroundColor: .systemBlue.withAlphaComponent(0.6))
        case .custom:
            self.workoutDescriptionLabel.text = "Customize your workout and become a pro."
            self.startButton.configuration = changeConfigurationForStartButton(baseBackgroundColor: UIColor(rgb: 0xEC6A5E))
        case .time:
            self.workoutDescriptionLabel.text = "Set time you want to exercise."
            self.startButton.configuration = changeConfigurationForStartButton(baseBackgroundColor: UIColor(rgb: 0xF4BF4F))
        }
        changeConfigurationForSettingsWorkoutButton()
    }
    
    //MARK: Selectors
    @objc func startButtonTapped() {
        //define transition
        let fingerWorkoutViewController = FingerWorkoutViewController()
        fingerWorkoutViewController.modalPresentationStyle = .fullScreen
        fingerWorkoutViewController.workoutParameters = self.workoutParameters
        
        present(fingerWorkoutViewController, animated: true)
    }
    
    @objc func changeGoalTypeButtonTapped() {
        let vc = GoalPickerViewController()
        vc.delegate = self
        vc.currentGoalType = self.workoutParameters.workoutGoal
        let controllerToPresent = UINavigationController(rootViewController: vc)
//        controllerToPresent.currentGoalType = self.workoutParameters.workoutGoal
        if let sheet = controllerToPresent.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 15
        }
        
        self.present(controllerToPresent, animated: true)
    }
    
    @objc func settingsWorkoutButtonTapped() {
        let vc = TimeGoalSettingsViewController()
        vc.delegate = self
        let parameters = self.workoutParameters
        vc.minutes = (parameters.durationForTimeGoal % 3600) / 60
        vc.seconds =  (parameters.durationForTimeGoal % 3600) % 60
        let controllerToPresent = UINavigationController(rootViewController: vc)
        if let sheet = controllerToPresent.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 15
        }
        
        self.present(controllerToPresent, animated: true)
    }
}

extension WorkoutViewController: GoalPickerDelegate {
    func getGoalType(_ goalType: WorkoutGoal) {
        self.workoutParameters.workoutGoal = goalType
        self.updateUI()
    }
}

extension WorkoutViewController: TimeGoalSettingsDelegate {
    func getTime(_ time: Int) {
        self.workoutParameters.durationForTimeGoal = time
        self.updateUI()
    }
}
