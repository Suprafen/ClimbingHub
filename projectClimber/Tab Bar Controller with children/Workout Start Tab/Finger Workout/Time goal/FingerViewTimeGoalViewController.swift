//
//  FingerViewTimeGoalViewController.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 7.04.22.
//

import UIKit
import SwiftUI
import RealmSwift

class FingerViewTimeGoalViewController: UIViewController {

    private let buttonsStackView: UIStackView = {
       let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = 20
        stack.isHidden = true
        
        return stack
    }()
    
    private let pauseButton: UIButton = {
        if #available(iOS 15, *) {
            var configuration = UIButton.Configuration.filled()
            configuration.image = UIImage(systemName: "pause.fill")
            configuration.baseBackgroundColor = UIColor(rgb: 0xF4BF4F)
            configuration.baseForegroundColor = UIColor(rgb: 0x8E5A1D)
            configuration.buttonSize = .large
            let button = UIButton(configuration: configuration, primaryAction: nil)
            button.addTarget(nil, action: #selector(pauseButtonTapped), for: .touchUpInside)
            
            return button
        } else {
            return UIButton()
        }
    }()
    
    private let cancelButton: UIButton = {
        if #available(iOS 15, *) {
            var configuration = UIButton.Configuration.filled()
            configuration.image = UIImage(systemName: "xmark")
            configuration.baseBackgroundColor = UIColor(rgb: 0xEC6A5E)
            configuration.baseForegroundColor = UIColor(rgb: 0x8C1A10)
            configuration.buttonSize = .large
            let button = UIButton(configuration: configuration, primaryAction: nil)
            button.addTarget(nil, action: #selector(cancelButtonTapped), for: .touchUpInside)
            
            return button
        } else {
            return UIButton()
        }
    }()
    
    private let restButton: UIButton = {
        if #available(iOS 15, *) {
            var configuration = UIButton.Configuration.filled()
            configuration.image = UIImage(systemName: "figure.stand")
            configuration.baseBackgroundColor = UIColor(rgb: 0x62C654)
            configuration.baseForegroundColor = UIColor(rgb: 0x296117)
            configuration.buttonSize = .large
            let button = UIButton(configuration: configuration, primaryAction: nil)
            button.addTarget(nil, action: #selector(restButtonTapped), for: .touchUpInside)
            
            return button
        } else {
            return UIButton()
        }
    }()
    //Label that appear only when need to count down before next split begins
    private let countDownLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 100, weight: .black)
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
    
    private let goalAnnouncementLabel: UILabel = {
        let label = UILabel()
        label.text = "Goal Complete!"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.isHidden = true
        
        return label
    }()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.trackTintColor = .systemGray6
        progressView.progressTintColor = .systemOrange
        progressView.setProgress(0, animated: false)
        progressView.isHidden = true
        
        return progressView
    }()
    
    //MARK: Properties
    
    // in seconds
    var timeGoal: Int = 0
    var realm: Realm
    
    private var countDownCounter: Int = 3
    private var totalTimeCounter: Int = 0
    private var splitTimeCounter: Int = 0
    
    private var countDownTimer: Timer!
    private var totalTimeTimer: Timer!
    private var splitTimer: Timer!
    
    private var splits: [Int] = []
    private var longestSplit: Int = 0
    
    private var isRestModeActive: Bool = false
    private var isPauseActive:Bool = false
    
    private let splitsTableView = UITableView()
        
    init(realmConfiguration: Realm.Configuration, timeGoal: Int) {
        self.timeGoal = timeGoal
        self.realm = try! Realm(configuration: realmConfiguration)
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
            countDownLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            countDownLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            
            splitLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 40),
            splitLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20),
            splitLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -20),
            
            progressView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20),
            progressView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -20),
            progressView.bottomAnchor.constraint(equalTo: tableViewBackgroundView.topAnchor, constant: -20),
            
            tableViewBackgroundView.topAnchor.constraint(greaterThanOrEqualTo: splitLabel.bottomAnchor, constant: 50),
            tableViewBackgroundView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20),
            tableViewBackgroundView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -20),
            tableViewBackgroundView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -20),
            
            tableViewTitleLabel.topAnchor.constraint(equalTo: tableViewBackgroundView.topAnchor, constant: 20),
            tableViewTitleLabel.leadingAnchor.constraint(equalTo: tableViewBackgroundView.leadingAnchor, constant: 20),
            
            splitsTableView.topAnchor.constraint(equalTo: tableViewTitleLabel.bottomAnchor, constant: 10),
            splitsTableView.leadingAnchor.constraint(equalTo: tableViewBackgroundView.leadingAnchor, constant: 20),
            splitsTableView.trailingAnchor.constraint(equalTo: tableViewBackgroundView.trailingAnchor, constant: -20),
            splitsTableView.bottomAnchor.constraint(equalTo: tableViewBackgroundView.bottomAnchor, constant: -20),
            
            goalAnnouncementLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            goalAnnouncementLabel.bottomAnchor.constraint(equalTo: tableViewBackgroundView.topAnchor, constant: -20),
            
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
        
        view.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(countDownLabel)
        view.addSubview(splitLabel)
        view.addSubview(tableViewBackgroundView)
        view.addSubview(tableViewTitleLabel)
        view.addSubview(splitsTableView)
        view.addSubview(buttonsStackView)
        view.addSubview(goalAnnouncementLabel)
        
        
        countDownLabel.translatesAutoresizingMaskIntoConstraints = false
        splitLabel.translatesAutoresizingMaskIntoConstraints = false
        tableViewBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        tableViewTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        splitsTableView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        goalAnnouncementLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    // MARK: Timers' perform methods
    
    func countDownTimerPerform(withInterval timeInterval: Double, duration countDownCounterValue: Int) {
        countDownCounter = countDownCounterValue
        countDownTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(countDownTimerFire), userInfo: nil, repeats: true)
    }

    func countDownTimerPerformCongratsLabel(withInterval timeInterval: Double, duration countDownCounterValue: Int) {
        countDownCounter = countDownCounterValue
        countDownTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(countDownTimerCongratsLabelShow), userInfo: nil, repeats: true)
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
    
    @objc func pauseButtonTapped(sender: UIButton) {
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
        
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                sender.transform = CGAffineTransform.identity
            }
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
            let listSplits = RealmSwift.List<Int>()
            
            listSplits.append(objectsIn: splits)
            // create an instance of workout
            let instance = Workout(totalTime: totalTimeCounter,
                date: Date(),
                splits: listSplits,
                workoutType: .fingerWorkout,
                goalType: .time,
                userID: app.currentUser?.id ?? "local_realm_dataBase"
            )
            
            try! realm.write {
                realm.add(instance)
            }
        } else {
            // Append the last split before view dismissed
            splits.append(splitTimeCounter)
            dismiss(animated: true, completion: nil)
            
            let listSplits = RealmSwift.List<Int>()
            
            listSplits.append(objectsIn: splits)
            
            let instance = Workout(totalTime: totalTimeCounter,
                date: Date(),
                splits: listSplits,
                workoutType: .fingerWorkout,
                goalType: .time,
                userID: app.currentUser?.id ?? "local_realm_dataBase"
            )
            
            try! realm.write {
                realm.add(instance)
            }
        }
    }
    
    @objc func restButtonTapped(sender: UIButton) {
        isRestModeActive.toggle()
        sender.setImage(isRestModeActive ? UIImage(named: "figure.on.handboard") : UIImage(systemName: "figure.stand"), for: .normal)
        // if is not valid it means we are in the rest mode
        if !splitTimer.isValid {
            splitLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 80, weight: .bold)
            
            UIView.animate(withDuration: 0.2) {
                self.splitLabel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            } completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    self.splitLabel.transform = CGAffineTransform.identity
                    self.splitLabel.text = "00:00:00"
                }
            }
            // awake timer
            splitTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(splitTimerFire), userInfo: nil, repeats: true)
            RunLoop.current.add(splitTimer, forMode: .common)
        } else {
            // If timer is valid turn rest mode
            
            // If the current split is bigger than previoous longest split
            // Redefine.
            if splitTimeCounter > longestSplit {
                self.longestSplit = splitTimeCounter
            }
            
            // Make sure that split is not equal to 0
            if splitTimeCounter != 0 {
                splits.append(splitTimeCounter)
            }
            self.splitsTableView.reloadData()
            // set counter's value to 0
            splitTimeCounter = 0
            
            UIView.animate(withDuration: 0.2) {
                self.splitLabel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            } completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    self.splitLabel.transform = CGAffineTransform.identity
                    self.splitLabel.text = "😴 REST"
                }
            }
            
            splitLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 80, weight: .bold)
            // invalidate timer
            splitTimer.invalidate()
        }
        
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                sender.transform = CGAffineTransform.identity
            }
        }
    }
    
    @objc func countDownTimerFire() {
        // perform task until true
        if countDownCounter > 1 {
            countDownCounter -= 1
            
            UIView.animate(withDuration: 0.2) {
                self.countDownLabel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            } completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    self.countDownLabel.transform = CGAffineTransform.identity
                    self.countDownLabel.text = String(self.countDownCounter)
                }
            }
            
        } else {
            // invalidate timer
            countDownTimer?.invalidate()
            countDownCounter = 3
            // Asign to nil
            countDownTimer = nil
            // Make count down label hidden
            self.countDownLabel.isHidden = true
            // Make everything visible
            self.tableViewBackgroundView.isHidden = false
            self.splitLabel.isHidden = false
            self.buttonsStackView.isHidden = false
            self.tableViewBackgroundView.isHidden = false
            self.tableViewTitleLabel.isHidden = false
            self.progressView.isHidden = false
            // Wake timers
            totalTimeTimerPerform(timeInterval: 1)
            splitTimerPerform(timeInterval: 1)
        }
    }
    
    // We need to show that a user achieved their goal
    // But for a little period of time
    
    @objc func countDownTimerCongratsLabelShow() {
        if countDownCounter > 0 {
            countDownCounter -= 1
        
        } else {
            countDownTimer?.invalidate()
            countDownTimer = nil
            UIView.animate(withDuration: 0.4) {
                self.goalAnnouncementLabel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            } completion: { _ in
                self.goalAnnouncementLabel.isHidden = true
            }
        }
    }

    @objc func totalTimeTimerFire() {
        
        if totalTimeCounter < timeGoal {
            self.progressView.setProgress(Float(self.totalTimeCounter)/Float(self.timeGoal), animated: true)
        } else if totalTimeCounter == timeGoal {
            self.progressView.isHidden = true
            self.countDownTimerPerformCongratsLabel(withInterval: 1.0, duration: self.countDownCounter)
            self.goalAnnouncementLabel.isHidden = false
            self.goalAnnouncementLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
            UIView.animate(withDuration: 0.4) {
                self.goalAnnouncementLabel.transform = .identity
            }
        }
        totalTimeCounter += 1
    }
    
    @objc func splitTimerFire() {
        splitTimeCounter += 1
        
//        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        let timeString = String.makeTimeString(seconds: splitTimeCounter, withLetterDescription: false)
        splitLabel.text = timeString
    }
}

//MARK: Table view protocols
extension FingerViewTimeGoalViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.splits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SplitTableViewCell.reuseIdentifier, for: indexPath) as! SplitTableViewCell
        let isLongestSplit = self.longestSplit == self.splits[indexPath.row]
        cell.configure(cellWithNumber: indexPath.row + 1, with: self.splits[indexPath.row], isLongestSplit: isLongestSplit)
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        return cell
    }
}
