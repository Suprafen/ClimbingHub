//
//  FingerWorkoutViewController.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 4.02.22.
//

import UIKit

// How does it work?
// Countdown timer appears on the screen 3..2..1.. Go
// Countdown timer was invalidated. At this moment started two timers:
// TotalTimeTimer and Split timer.
// ---------
// REST BUTTON
// When user tap rest button (the most left one) rest mode activated;
// Split timer was invalidated. Splits array is appanded by split;
// Total time timer, meanwhile, still counting.
// If user tap to rest button, the action is active workout mode and new split is calculating.
// ---------
// PAUSE MODE
// Both timers will be invalidated (if were active);
// Rest mode button is disabled, although if a user was in the rest mode this state would be save;
// Another tap on pause button returns to previous workout state either rest or active mode;
// ---------
// CANCEL
// Check wheter timers are active. If so, invalidate them
// If workout lasted less than 30 seconds, data won't be saved and splits array will be erased, regardless number of splits;
// Otherwise, array will be populated last time with split
// View will be dismissed in any case

class FingerWorkoutViewController: UIViewController {

    private let outermostStackView: UIStackView = {
       
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.isHidden = true
        
        return stack
    }()
    
    private let buttonsStackView: UIStackView = {
       let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.spacing = 20
        
        return stack
    }()
    
    private let countDownLabelStack: UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        
        return stack
    }()
    private let pauseButton: UIButton = {
        if #available(iOS 15, *) {
            var configuration = UIButton.Configuration.filled()
            configuration.image = UIImage(systemName: "pause.fill")
            configuration.background.backgroundColor = .systemYellow
            let button = UIButton(configuration: configuration, primaryAction: nil)
            button.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
            
            return button
        } else {
            return UIButton()
        }
    }()
    
    private let cancelButton: UIButton = {
        if #available(iOS 15, *) {
            var configuration = UIButton.Configuration.filled()
            configuration.image = UIImage(systemName: "multiply")
            configuration.background.backgroundColor = .systemRed
            let button = UIButton(configuration: configuration, primaryAction: nil)
            button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
            
            return button
        } else {
            return UIButton()
        }
    }()
    
    private let restButton: UIButton = {
        if #available(iOS 15, *) {
            var configuration = UIButton.Configuration.filled()
            configuration.image = UIImage(systemName: "figure.stand")
            configuration.background.backgroundColor = .systemTeal
            let button = UIButton(configuration: configuration, primaryAction: nil)
            button.addTarget(self, action: #selector(restButtonTapped), for: .touchUpInside)
            
            return button
        } else {
            return UIButton()
        }
    }()
    //Label that appear only when need to count down before next split begins
    private let countDownLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedSystemFont(ofSize: 30, weight: .regular)
        label.textColor = .black
        label.text = "3"
        label.textAlignment = .center
        
        return label
    }()
    // Split timer label
    private let splitLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedSystemFont(ofSize: 30, weight: .regular)
        label.textColor = .black
        label.text = "00:00"
        label.textAlignment = .center
        
        return label
    }()
    // Total time timer label
    private let totalTimeLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.monospacedSystemFont(ofSize: 30, weight: .regular)
        label.textColor = .gray
        label.text = "00:00"
        label.textAlignment = .center
        
        return label
    }()
    
    //MARK: Properties
    
    private var countDownCounter: Int = 3
    private var totalTimeCounter: Int = 0
    private var splitTimeCounter: Int = 0
    
    private var countDownTimer: Timer!
    private var totalTimeTimer: Timer!
    private var splitTimer: Timer!
    
    private var splits: [Int] = []
    private var currentSplit: Int = 0
    
    private var isRestModeActive: Bool = false
    private var isPauseActive:Bool = false
    
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        countDownTimerPerform(withInterval: 1, duration: 3)
    }
    
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        countDownLabel.center = view.center
        
        NSLayoutConstraint.activate([
            // outermost stack view constraints
            outermostStackView.topAnchor.constraint(equalTo: view.topAnchor),
            outermostStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            outermostStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            outermostStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            countDownLabelStack.topAnchor.constraint(equalTo: view.topAnchor),
            countDownLabelStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            countDownLabelStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            countDownLabelStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
    }
    
    func configureView() {
        self.view.backgroundColor = .white
        
        buttonsStackView.addArrangedSubview(pauseButton)
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(restButton)
        
        
        outermostStackView.addArrangedSubview(splitLabel)
        outermostStackView.addArrangedSubview(buttonsStackView)
        outermostStackView.addArrangedSubview(totalTimeLabel)
        
        countDownLabelStack.addArrangedSubview(countDownLabel)
        
        outermostStackView.translatesAutoresizingMaskIntoConstraints = false
        countDownLabelStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(outermostStackView)
        view.addSubview(countDownLabelStack)
    }
    // MARK: Timers' perform methods
    
    func countDownTimerPerform(withInterval timeInterval: Double, duration countDownCounterValue: Int) {
        countDownCounter = countDownCounterValue
        countDownTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(countDownTimerFire), userInfo: nil, repeats: true)
    }

    func totalTimeTimerPerform(timeInterval: Double) {
        totalTimeTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(totalTimeTimerFire), userInfo: nil, repeats: true)
        RunLoop.current.add(totalTimeTimer, forMode: .common)
    }
    
    func splitTimerPerform(timeInterval: Double) {
        splitTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(splitTimerFire), userInfo: nil, repeats: true)
        RunLoop.current.add(splitTimer, forMode: .common)
    }
    
    // MARK: Selectors
    
    @objc func pauseButtonTapped() {
        isPauseActive.toggle()
        self.pauseButton.setImage(isPauseActive ? UIImage(systemName: "arrow.clockwise") : UIImage(systemName: "pause.fill"), for: .normal)
        
        // if both timers are not active, means pause button tapped,
        // we'll wake them
        if !splitTimer.isValid && !totalTimeTimer.isValid {
            //rest button again enable for us
            restButton.isEnabled = true
            splitLabel.textColor = .black
            // if the rest mode is not active launch split timer
            // otherwise do nothing
            if !isRestModeActive {
                splitTimerPerform(timeInterval: 1)
            }
            // awake main total time timer
            totalTimeTimerPerform(timeInterval: 1)
            // if conditional different, that means that timers are active,
            // so we invalidate them and turn on pause mode
        } else {
            // the rest button is no longer available
            restButton.isEnabled = false
            splitLabel.textColor = .systemGray
            // if the rest mode is not active, invalidate split timer
            if !isRestModeActive {
                splitTimer.invalidate()
            }
            // invalidate main timer
            totalTimeTimer.invalidate()
        }
    }
    
    @objc func cancelButtonTapped() {
        // check if timers are valid
        if splitTimer.isValid { splitTimer.invalidate() }
        if totalTimeTimer.isValid { totalTimeTimer.invalidate() }
        
        // if overall time is less than 30 seconds, workout won't be loaded to the history
        if totalTimeCounter < 30 {
            // remove any splits
            splits = []
            dismiss(animated: true, completion: nil)
        } else if isRestModeActive{
            // If rest mode active I don't want to save last split, which will be 0
            // In other cases it's ok
            dismiss(animated: true, completion: nil)
            print(splits)
            // create an instance of workout
            let instance = FingerWorkout()
            instance.date = Date()
            // append splits to a model's list
            instance.splits.append(objectsIn: splits)
            // save insantiated object
            RealmManager.sharedInstance.saveData(object: instance)
        } else {
            // append the last split before view dismissed
            splits.append(splitTimeCounter)
            dismiss(animated: true, completion: nil)
            
            let instance = FingerWorkout()
            instance.date = Date()
            instance.splits.append(objectsIn: splits)
            RealmManager.sharedInstance.saveData(object: instance)
            
        }
    }
    
    @objc func restButtonTapped() {
        isRestModeActive.toggle()
        self.restButton.setImage(isRestModeActive ? UIImage(systemName: "figure.wave") : UIImage(systemName: "figure.stand"), for: .normal)
        // if is not valid it means we are in the rest mode
        if !splitTimer.isValid {
            splitLabel.font = UIFont.monospacedSystemFont(ofSize: 30, weight: .regular)
            splitLabel.text = "00 : 00"
            // awake timer
            splitTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(splitTimerFire), userInfo: nil, repeats: true)
            RunLoop.current.add(splitTimer, forMode: .common)
        } else {
            // if timer is valid turn rest mode
            // append last split to splits array
            splits.append(splitTimeCounter)
            // set counter's value to 0
            splitTimeCounter = 0
            splitLabel.text = "REST"
            splitLabel.font = UIFont.boldSystemFont(ofSize: 30)
            // invalidate timer
            splitTimer.invalidate()
        }
    }
    
    @objc func countDownTimerFire() {
        // perform task until true
        if countDownCounter > 1 {
            countDownCounter -= 1
        
            countDownLabel.text = String(countDownCounter)
        } else {
            // invalidate timer
            countDownTimer?.invalidate()
            // asign to nil
            countDownTimer = nil
            // make stack where was label hidden
            self.countDownLabelStack.isHidden = true
            // show finger workout interface
            self.outermostStackView.isHidden = false
            // awake timer
            totalTimeTimerPerform(timeInterval: 1)
            splitTimerPerform(timeInterval: 1)
        }
    }
    
    @objc func totalTimeTimerFire() {
        totalTimeCounter += 1
        
        let time = secondsToHoursMinutesSeconds(seconds: totalTimeCounter)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        totalTimeLabel.text = timeString
    }
    
    @objc func splitTimerFire() {
        splitTimeCounter += 1
        
        let time = secondsToHoursMinutesSeconds(seconds: splitTimeCounter)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        splitLabel.text = timeString
    }
    //MARK: Helper methods
    
    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int){
        return ((seconds / 3600), ((seconds % 3600) / 60), ((seconds % 3600) % 60))
    }
    
    func makeTimeString(hours: Int, minutes: Int, seconds: Int) -> String{
        var timeStirng = ""
        if hours > 0 {
            timeStirng += String(format: "%02d", hours)
            timeStirng += " : "
        }
        
        timeStirng += String(format: "%02d", minutes)
        timeStirng += " : "
        timeStirng += String(format: "%02d", seconds)
        timeStirng += ""
        
        return timeStirng
    }
}
