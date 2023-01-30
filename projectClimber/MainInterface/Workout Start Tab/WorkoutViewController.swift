//
//  WorkoutViewController.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 4.02.22.
//

import UIKit
import RealmSwift
//class with HUGE start button

class WorkoutViewController: UIViewController {

    private let stackView:  UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 8
        
        return stackView
    }()
    
    private let firstTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Finger Workout"
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
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
    
    private let workoutSettingsRepresentation: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.textColor = .white
        label.numberOfLines = 0
        
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
            configuration.imagePlacement = .leading
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
        var configuration = UIButton.Configuration.gray()
        configuration.image = UIImage(systemName: "gear")
        configuration.buttonSize = .large
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(nil, action: #selector(settingsWorkoutButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        
        return button
    }()
    
    private let showGoalTypesButton: UIButton = {
        var configuration = UIButton.Configuration.gray()
//        configuration.baseBackgroundColor = .white
        configuration.image = UIImage(systemName: "ellipsis")
        configuration.buttonSize = .large
        let button = UIButton(configuration: configuration, primaryAction: nil)

        button.addTarget(nil, action: #selector(changeGoalTypeButtonTapped), for: .touchUpInside)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return button
    }()

    
    let userDefaults = UserDefaults.standard
    var workoutParameters: WorkoutParamters = WorkoutParamters()
    var userData: User?
    var realmConfiguration: Realm.Configuration
    
    init(userData: User?, realmConfiguration: Realm.Configuration) {
        self.userData = userData
        self.realmConfiguration = realmConfiguration
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Check for data in user defaults
        // If there something we'd saved before, get it
        // Otherwise use return 
        self.workoutParameters = decodeData(forKey: "SavedWorkoutParameters")
        configureView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            
            overviewFingerWorkoutBackground.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0),
            overviewFingerWorkoutBackground.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0),
            overviewFingerWorkoutBackground.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0),
            
            firstTitleLabel.topAnchor.constraint(equalTo: overviewFingerWorkoutBackground.topAnchor, constant: 20),
            firstTitleLabel.leadingAnchor.constraint(equalTo: overviewFingerWorkoutBackground.leadingAnchor, constant: 20),
            
            workoutDescriptionLabel.topAnchor.constraint(equalTo: firstTitleLabel.bottomAnchor, constant: 15),
            workoutDescriptionLabel.leadingAnchor.constraint(equalTo: overviewFingerWorkoutBackground.leadingAnchor, constant: 20),
            workoutDescriptionLabel.trailingAnchor.constraint(equalTo: overviewFingerWorkoutBackground.trailingAnchor, constant: -20),
            
            workoutSettingsRepresentation.topAnchor.constraint(equalTo: workoutDescriptionLabel.bottomAnchor, constant: 15),
            workoutSettingsRepresentation.leadingAnchor.constraint(equalTo: overviewFingerWorkoutBackground.leadingAnchor, constant: 20),
            workoutSettingsRepresentation.trailingAnchor.constraint(equalTo: overviewFingerWorkoutBackground.trailingAnchor, constant: -20),
            
            stackView.topAnchor.constraint(equalTo: overviewFingerWorkoutBackground.bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -10)
        ])
    }
    
    //MARK: Helper methods
    // Decode method that helps to retreive info from user defaults
    func decodeData(forKey key: String) -> WorkoutParamters {
        if let savedParameters = self.userDefaults.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            if let parameters = try? decoder.decode(WorkoutParamters.self, from: savedParameters) {
                return parameters
            }
        }
        return WorkoutParamters()
    }
    
    // Encode data for saving to user defaults
    func encodeData(_ data: WorkoutParamters) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(data) {
            self.userDefaults.set(encoded, forKey: "SavedWorkoutParameters")
        }
    }
    
    func setGoal() {
        workoutParameters.workoutGoal = .openGoal
    }
    
    func configureView() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Workout"
        
        stackView.addArrangedSubview(startButton)
        stackView.addArrangedSubview(settingsWorkoutButton)
        stackView.addArrangedSubview(showGoalTypesButton)
        
        view.addSubview(overviewFingerWorkoutBackground)
        view.addSubview(firstTitleLabel)
        view.addSubview(workoutDescriptionLabel)
        view.addSubview(workoutSettingsRepresentation)
        
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        overviewFingerWorkoutBackground.translatesAutoresizingMaskIntoConstraints = false
        firstTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        workoutDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        workoutSettingsRepresentation.translatesAutoresizingMaskIntoConstraints = false
        
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
        var configuration = UIButton.Configuration.gray()
        configuration.imagePadding = 10
        configuration.buttonSize = .large
        
        let parameters = self.workoutParameters
        
        switch parameters.workoutGoal {
        case .openGoal:
            workoutSettingsRepresentation.text = ""
            settingsWorkoutButton.isEnabled = false
        case .custom:
            // Need to calculate duration according to the duration of each split and rest and their quantity
            let duration = parameters.durationOfWorkout
            workoutSettingsRepresentation.text = "Splits: \(parameters.numberOfSplits)\nDuration: \(String.makeTimeString(seconds: duration, withLetterDescription: true))"
            settingsWorkoutButton.isEnabled = true
        case .time:
            workoutSettingsRepresentation.text = "Duration: \(String.makeTimeString(seconds: parameters.durationForTimeGoal, withLetterDescription: true))"
            settingsWorkoutButton.isEnabled = true
        }
        configuration.image = UIImage(systemName: "gear")
        self.settingsWorkoutButton.configuration = configuration
    }
    
    func updateUI() {
        switch self.workoutParameters.workoutGoal {
        case .openGoal:
            self.workoutDescriptionLabel.text  = "Open goal finger workout helps you to develop your grip strength."
            self.startButton.configuration = changeConfigurationForStartButton(baseBackgroundColor: .systemBlue.withAlphaComponent(0.6))
        case .custom:
            self.workoutDescriptionLabel.text = "Customize your workout and become a pro."
            self.startButton.configuration = changeConfigurationForStartButton(baseBackgroundColor: UIColor(rgb: 0xAB80E2))
        case .time:
            self.workoutDescriptionLabel.text = "Set time you want to exercise."
            self.startButton.configuration = changeConfigurationForStartButton(baseBackgroundColor: UIColor(rgb: 0xF4BF4F))
        }
        changeConfigurationForSettingsWorkoutButton()
    }
    
    //MARK: Selectors
    @objc func startButtonTapped() {
        // Define transition
        let currentGoal = self.workoutParameters.workoutGoal
        switch currentGoal {
        case .openGoal:
            let controllerToPresent = FingerWorkoutViewController(realmConfiguration: self.realmConfiguration)
            controllerToPresent.modalPresentationStyle = .fullScreen
            self.present(controllerToPresent, animated: true)
        case .time:
            let controllerToPresent = FingerViewTimeGoalViewController(realmConfiguration: self.realmConfiguration,
                timeGoal: self.workoutParameters.durationForTimeGoal
            )
            controllerToPresent.modalPresentationStyle = .fullScreen
            self.present(controllerToPresent, animated: true)
        case .custom:
            let controllerToPresent = FingerWorkoutCustomGoalViewController(realmConfiguration: self.realmConfiguration, workoutParameters: self.workoutParameters)
            controllerToPresent.modalPresentationStyle = .fullScreen
            self.present(controllerToPresent, animated: true)
        }
    }
    
    @objc func changeGoalTypeButtonTapped() {
        let vc = GoalPickerViewController()
        vc.delegate = self
        vc.currentGoalType = self.workoutParameters.workoutGoal
        let controllerToPresent = UINavigationController(rootViewController: vc)
        if let sheet = controllerToPresent.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 15
        }
        
        self.present(controllerToPresent, animated: true)
    }
    
    @objc func settingsWorkoutButtonTapped() {
        
        if workoutParameters.workoutGoal == .time {
            
            let timeGoalController = TimeGoalSettingsViewController()
            timeGoalController.delegate = self
            let parameters = self.workoutParameters
            timeGoalController.minutes = (parameters.durationForTimeGoal % 3600) / 60
            timeGoalController.seconds =  (parameters.durationForTimeGoal % 3600) % 60
            let controllerToPresent = UINavigationController(rootViewController: timeGoalController)
            if let sheet = controllerToPresent.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.preferredCornerRadius = 15
            }
            self.present(controllerToPresent, animated: true)
            
        } else if workoutParameters.workoutGoal == .custom {
            
            let customGoalController = CustomGoalSettingsViewController()
            let parameters = self.workoutParameters
            customGoalController.delegate = self
            customGoalController.timeForSplit = parameters.durationOfEachSplit
            customGoalController.timeForRest = parameters.durationOfEachRest
            customGoalController.numberOfSplits = parameters.numberOfSplits
            if let sheet = customGoalController.sheetPresentationController {
                sheet.prefersGrabberVisible = true
                sheet.detents = [.large()]
                sheet.preferredCornerRadius = 15
            }
            self.present(customGoalController, animated: true)
            
        }
    }
}

extension WorkoutViewController: GoalPickerDelegate {
    func getGoalType(_ goalType: WorkoutGoal) {
        self.workoutParameters.workoutGoal = goalType
        encodeData(self.workoutParameters)
        self.updateUI()
    }
}

extension WorkoutViewController: TimeGoalSettingsDelegate {
    func getTime(_ time: Int) {
        self.workoutParameters.durationForTimeGoal = time
        encodeData(self.workoutParameters)
        self.updateUI()
    }
}

extension WorkoutViewController: CustomGoalSettingsProtocol {
    func retrieveSettingsForCustomGoalType(numberOfSplits: Int, timeForSplit: Int, timeForRest: Int) {
        self.workoutParameters.numberOfSplits = numberOfSplits
        self.workoutParameters.durationOfEachSplit = timeForSplit
        self.workoutParameters.durationOfEachRest = timeForRest
        encodeData(self.workoutParameters)
        self.updateUI()
    }
}
