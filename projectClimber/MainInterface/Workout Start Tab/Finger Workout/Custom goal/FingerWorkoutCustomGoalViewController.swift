//
//  FingerWorkoutCustomGoalViewController.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 11.04.22.
//
import UIKit
import SwiftUI
import RealmSwift

class FingerWorkoutCustomGoalViewController: UIViewController {

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
            button.addTarget(nil, action: #selector(anyButtonTapped(_:)), for: .touchDown)
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
            button.addTarget(nil, action: #selector(anyButtonTapped(_:)), for: .touchDown)
            button.addTarget(nil, action: #selector(cancelButtonTapped), for: .touchUpInside)
            
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
    
    //MARK: Properties
    
    var workoutParameters: WorkoutParamters
    var realm: Realm
    
    private var countDownCounter: Int = 3
    private var splitsDone: Int = 0
    private var totalTimeCounter: Int = 0
    private var splitTimeCounter: Int = 0
    private var restTimeCounter: Int = 0
    
    private var countDownTimer: Timer!
    private var totalTimeTimer: Timer!
    private var splitTimer: Timer!
    private var restTimer: Timer!
    
    private var splits: [Int] = []
    private var longestSplit: Int = 0
    
    private var isRestModeActive: Bool = false
    private var isPauseActive:Bool = false
    
    private let splitsTableView = UITableView()
        
    
    init(realmConfiguration: Realm.Configuration, workoutParameters: WorkoutParamters) {
        self.realm = try! Realm(configuration: realmConfiguration)
        self.workoutParameters = workoutParameters
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.restTimeCounter = self.workoutParameters.durationOfEachRest
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
    
    func restTimerPerform(timeInterval: Double) {
        restTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(restTimerFire), userInfo: nil, repeats: true)
        RunLoop.current.add(splitTimer, forMode: .common)
    }
    
    // MARK: Selectors
    
    @objc func pauseButtonTapped(sender: UIButton) {
        isPauseActive.toggle()
        self.pauseButton.setImage(isPauseActive ? UIImage(systemName: "play.fill") : UIImage(systemName: "pause.fill"), for: .normal)
        
        // if both timers are not active, means pause button tapped,
        // we'll wake them
        if !splitTimer.isValid && !totalTimeTimer.isValid && !isRestModeActive && !(restTimer?.isValid ?? false) {
            //rest button again enable for us
            
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
        } else if isRestModeActive && totalTimeTimer.isValid && !splitTimer.isValid {
            restTimer.invalidate()
            totalTimeTimer.invalidate()
            
            splitLabel.textColor = .systemGray
        } else if isRestModeActive && !totalTimeTimer.isValid && !splitTimer.isValid{
            restTimerPerform(timeInterval: 1)
            totalTimeTimerPerform(timeInterval: 1)
            splitLabel.textColor = .black
        } else {
            splitLabel.textColor = .systemGray
            // if the rest mode is not active, invalidate split timer
            if !isRestModeActive {
                splitTimer.invalidate()
            }
            // invalidate main timer
            totalTimeTimer.invalidate()
        }
        
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform.identity
        }
    }
    
    @objc func cancelButtonTapped(sender: UIButton) {
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
                goalType: .custom,
                userID: app.currentUser?.id ?? "local_realm_dataBase"
            )
            
            try! realm.write {
                realm.add(instance)
            }
        } else {
            // append the last split before view dismissed
            splits.append(splitTimeCounter)
            dismiss(animated: true, completion: nil)
            
            let listSplits = RealmSwift.List<Int>()
            
            listSplits.append(objectsIn: splits)
            
            let instance = Workout(totalTime: totalTimeCounter,
                date: Date(),
                splits: listSplits,
                workoutType: .fingerWorkout,
                goalType: .custom,
                userID: app.currentUser?.id ?? "local_realm_dataBase"
            )
            
            try! realm.write {
                realm.add(instance)
            }
            
        }
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform.identity
        }
    }
        
    @objc func anyButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0) {
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
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
    }
    
    @objc func splitTimerFire() {
        // This one is useful, because dismissed the view
        // And not going to start another iteration whether splits were done
        guard splitsDone < workoutParameters.numberOfSplits else {
            splitTimer.invalidate()
            //TODO: Add an instance to the realm
            dismiss(animated: true)
            return
        }
        
        // Timer is going until we've got to the desirable number in duration for split
        if splitTimeCounter < workoutParameters.durationOfEachSplit {
            self.splitTimeCounter += 1
            let timeString = String.makeTimeString(seconds: splitTimeCounter, withLetterDescription: false)
            splitLabel.text = timeString
        } else {
            // Append split to the array
            self.splits.append(self.splitTimeCounter)
            // Reload table view
            self.splitsTableView.reloadData()
            // Asign split time counter value to duration of rest, because they're using the same label
            // So for smooth user experience we're doing this.
            self.splitTimeCounter = self.workoutParameters.durationOfEachRest
            self.restTimeCounter = self.workoutParameters.durationOfEachRest
            self.splitsDone += 1
            // If we've done every split we'd planned to do
            // Preform the code
            guard splitsDone < workoutParameters.numberOfSplits else {
                
            let listSplits = RealmSwift.List<Int>()
                
            listSplits.append(objectsIn: splits)
            // Create an instance
            let instance = Workout(totalTime: totalTimeCounter,
                date: Date(),
                splits: listSplits,
                workoutType: .fingerWorkout,
                goalType: .custom,
                userID: app.currentUser?.id ?? "local_realm_dataBase"
            )
            // Try to add this instance to the realm
                try! realm.write {
                    realm.add(instance)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(20)) {
                    self.dismiss(animated: true) 
                }
                return
            }
            splitTimer.invalidate()
            // Perform rest timer after invalidating
            self.restTimerPerform(timeInterval: 1)
            
            UIView.animate(withDuration: 0.2, delay: 0) {
                self.splitLabel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            } completion: { _ in
                UIView.animate(withDuration: 0.2, delay: 0) {
                    self.splitLabel.transform = .identity
                    self.splitLabel.text = "\(self.splitTimeCounter)"
                }
            }
        }
    }
    
    @objc func restTimerFire() {
        isRestModeActive = true
        if restTimeCounter > 1 {
            self.restTimeCounter -= 1
            let timeString = restTimeCounter
            splitLabel.text = "\(timeString)"
        } else {
            self.splitTimeCounter = 0
            restTimer.invalidate()
            isRestModeActive = false
            self.splitTimerPerform(timeInterval: 1)
            
            UIView.animate(withDuration: 0.2, delay: 0) {
                self.splitLabel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            } completion: { _ in
                UIView.animate(withDuration: 0.2, delay: 0) {
                    self.splitLabel.transform = .identity
                    self.splitLabel.text = String.makeTimeString(seconds: self.splitTimeCounter, withLetterDescription: false)
                }
            }
        }
    }
}

//MARK: Table view protocols
extension FingerWorkoutCustomGoalViewController: UITableViewDelegate, UITableViewDataSource {
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
