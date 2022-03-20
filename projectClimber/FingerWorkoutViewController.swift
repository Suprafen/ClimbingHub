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
        stack.isHidden = true
        
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
            configuration.buttonSize = .large
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
            configuration.buttonSize = .large
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
            configuration.buttonSize = .large
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
        label.font = UIFont.systemFont(ofSize: 100, weight: .black)
        label.textColor = .black
        label.text = "3"
        label.textAlignment = .center
        
        return label
    }()
    // Split timer label
    private let splitLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 80, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textColor = .black
        label.text = "00:00:00"
        label.textAlignment = .center
        label.isHidden = true
        
        return label
    }()
    // Total time timer label
    private let totalTimeLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.monospacedSystemFont(ofSize: 30, weight: .regular)
        label.textColor = .gray
        label.text = "00:00:00"
        label.textAlignment = .center
        
        return label
    }()
    
    private let tableViewTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        label.text = "Attempts"
        label.textColor = .white
        label.isHidden = true
        
        return label
    }()
    
    private let tableViewBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue.withAlphaComponent(0.8)
        view.layer.cornerRadius = 15
        view.isHidden = true
        view.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2/2.5).isActive = true
        
        return view
    }()
    
    //MARK: Properties
    
    private var countDownCounter: Int = 3
    private var totalTimeCounter: Int = 0
    private var splitTimeCounter: Int = 0
    
    private var countDownTimer: Timer!
    private var totalTimeTimer: Timer!
    private var splitTimer: Timer!
    
    private var splits: [Int] = []
//    private var currentSplit: Int = 0
    
    private var isRestModeActive: Bool = false
    private var isPauseActive:Bool = false
    
    private let splitsTableView = UITableView()
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        countDownTimerPerform(withInterval: 1, duration: 3)
    }
    
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let margins = view.layoutMarginsGuide
        countDownLabel.center = view.center
        
        NSLayoutConstraint.activate([
            countDownLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            countDownLabel.centerYAnchor.constraint(equalTo: margins.centerYAnchor),
            
            
            splitLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 40),
            splitLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20),
            splitLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -20),
            
            tableViewBackgroundView.topAnchor.constraint(greaterThanOrEqualTo: splitLabel.bottomAnchor, constant: 50),
            tableViewBackgroundView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20),
            tableViewBackgroundView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -20),
            tableViewBackgroundView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -20),
            
            tableViewTitleLabel.topAnchor.constraint(equalTo: tableViewBackgroundView.topAnchor, constant: 20),
            tableViewTitleLabel.leadingAnchor.constraint(equalTo: tableViewBackgroundView.leadingAnchor, constant: 20),
            
            splitsTableView.topAnchor.constraint(equalTo: tableViewTitleLabel.bottomAnchor, constant: 10),
            splitsTableView.leadingAnchor.constraint(equalTo: tableViewBackgroundView.leadingAnchor, constant: 20),
            splitsTableView.trailingAnchor.constraint(equalTo: tableViewBackgroundView.trailingAnchor, constant: -20),
            splitsTableView.bottomAnchor.constraint(equalTo: tableViewBackgroundView.bottomAnchor, constant: -20),
            
            buttonsStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -20),
            buttonsStackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -20)
            
        ])
    }
    
    func configureView() {
        self.view.backgroundColor = .white
        splitsTableView.delegate = self
        splitsTableView.dataSource = self
        splitsTableView.register(SplitTableViewCell.self, forCellReuseIdentifier: SplitTableViewCell.reuseIdentifier)
        splitsTableView.backgroundColor = UIColor.clear
        splitsTableView.separatorStyle = .none
        
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(pauseButton)
        buttonsStackView.addArrangedSubview(restButton)
        
        view.addSubview(countDownLabel)
        view.addSubview(splitLabel)
        view.addSubview(tableViewBackgroundView)
        view.addSubview(tableViewTitleLabel)
        view.addSubview(splitsTableView)
        view.addSubview(buttonsStackView)
        
        countDownLabel.translatesAutoresizingMaskIntoConstraints = false
        splitLabel.translatesAutoresizingMaskIntoConstraints = false
        tableViewBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        tableViewTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        splitsTableView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
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
        self.pauseButton.setImage(isPauseActive ? UIImage(systemName: "play.fill") : UIImage(systemName: "pause.fill"), for: .normal)
        
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
            let instance = Workout()
            instance.date = Date()
            // append splits to a model's list
            instance.splits.append(objectsIn: splits)
            // save insantiated object
            instance.totalTime = totalTimeCounter
            RealmManager.sharedInstance.saveData(object: instance)
        } else {
            // append the last split before view dismissed
            splits.append(splitTimeCounter)
            dismiss(animated: true, completion: nil)
            
            let instance = Workout()
            instance.date = Date()
            instance.splits.append(objectsIn: splits)
            instance.totalTime = totalTimeCounter
            RealmManager.sharedInstance.saveData(object: instance)
            
        }
    }
    
    @objc func restButtonTapped() {
        isRestModeActive.toggle()
        self.restButton.setImage(isRestModeActive ? UIImage(systemName: "figure.wave") : UIImage(systemName: "figure.stand"), for: .normal)
        // if is not valid it means we are in the rest mode
        if !splitTimer.isValid {
            splitLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 80, weight: .bold)
            splitLabel.text = "00:00:00"
            // awake timer
            splitTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(splitTimerFire), userInfo: nil, repeats: true)
            RunLoop.current.add(splitTimer, forMode: .common)
        } else {
            // if timer is valid turn rest mode
            // append last split to splits array
            splits.append(splitTimeCounter)
            self.splitsTableView.reloadData()
            // set counter's value to 0
            splitTimeCounter = 0
            splitLabel.text = "😴 REST"
            splitLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 80, weight: .bold)
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
            // make label hidden
            self.countDownLabel.isHidden = true
            // make everything visible
            self.tableViewBackgroundView.isHidden = false
            self.splitLabel.isHidden = false
            self.buttonsStackView.isHidden = false
            self.tableViewBackgroundView.isHidden = false
            self.tableViewTitleLabel.isHidden = false
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
        
//        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        let timeString = String.makeTimeString(seconds: splitTimeCounter, withLetterDescription: false)
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

//MARK: Table view protocols
extension FingerWorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.splits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SplitTableViewCell.reuseIdentifier, for: indexPath) as! SplitTableViewCell
        
        cell.configure(cellWithNumber: indexPath.row + 1, with: self.splits[indexPath.row])
        cell.backgroundColor = UIColor.clear
        return cell
    }
}
