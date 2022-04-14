//
//  CustomGoalSettingsViewController.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 4.04.22.
//

import UIKit

protocol CustomGoalSettingsProtocol {
    func retrieveSettingsForCustomGoalType(numberOfSplits: Int, timeForSplit: Int, timeForRest: Int)
}

class CustomGoalSettingsViewController: UIViewController {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Custom Goal"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        
        return label
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        
        return tableView
    }()
    
    let saveButton: UIButton = {

        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.addTarget(nil, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.addTarget(nil, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    var delegate: CustomGoalSettingsProtocol?
    
    var numberOfSplits = 0
    var timeForSplit = 0
    var timeForRest = 0
    
    let titleSplitIndexPath = IndexPath(row: 0, section: 1)
    let splitPickerIndexPath = IndexPath(row: 1, section: 1)
    var isSplitPickerVisible = false
    
    let titleRestIndexPath = IndexPath(row: 2, section: 1)
    let restPickerIndexPath = IndexPath(row: 3, section: 1)
    var isRestPickerVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: #selector(saveButtonTapped))

        configureView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
        
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 35),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            saveButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            cancelButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    //MARK: Helper methods
    func configureView() {
        self.view.addSubview(tableView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(saveButton)
        self.view.addSubview(cancelButton)
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.saveButton.translatesAutoresizingMaskIntoConstraints = false
        self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: Selectors
    @objc func saveButtonTapped() {
        delegate?.retrieveSettingsForCustomGoalType(numberOfSplits: self.numberOfSplits, timeForSplit: self.timeForSplit, timeForRest: self.timeForRest)
        dismiss(animated: true)
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
}

extension CustomGoalSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case splitPickerIndexPath where isSplitPickerVisible == false:
            return 0
        case restPickerIndexPath where isRestPickerVisible == false:
            return 0
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case splitPickerIndexPath:
            return 190
        case restPickerIndexPath:
            return 190
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.beginUpdates()
        
        if indexPath == titleSplitIndexPath && isRestPickerVisible == false {
            isSplitPickerVisible.toggle()
        } else if indexPath == titleRestIndexPath && isSplitPickerVisible == false {
            isRestPickerVisible.toggle()
        }else if indexPath == titleRestIndexPath || indexPath == titleSplitIndexPath{
            isRestPickerVisible.toggle()
            isSplitPickerVisible.toggle()
        } else {
            return
        }
        tableView.reloadRows(at: [splitPickerIndexPath], with: .fade)
        tableView.reloadRows(at: [restPickerIndexPath], with: .fade)
        tableView.endUpdates()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 4
        case 2:
            return 2
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        switch section {
        // The first section
        case 0:
            switch(indexPath.row) {
            // Stepper cell
            case 0:
                let cell = NumberOfSplitsStaticCell()
                cell.numberOfSplitsLabel.text = "\(numberOfSplits)"
                cell.numberOfSplitsStepper.value = Double(numberOfSplits)
                cell.delegate = self
                cell.selectionStyle = .none
                
                return cell
            default:
                return UITableViewCell()
            }
//         The second section
        case 1:
            switch(indexPath.row){
            // Title cell
            case 0:
                let cell = TitleCell()
                cell.titleLabel.text = "Split Duration"
                cell.numberTitleLabel.text = String.makeTimeString(seconds: timeForSplit, withLetterDescription: true)
                return cell
            // Picker cell
            case 1:
                // indexPath - using for tracking which one will be changed
                // isSplitPicker - boolean value to track whether was split picker or rest picker;
                // For retrieving right value
                // minutes and seconds converted time for time picker's default row values
                let cell = TimePickerCell()
                cell.delegate = self
                cell.indexPath = titleSplitIndexPath
                cell.isSplitPicker = true
                cell.minutes = (self.timeForSplit % 3600) / 60
                cell.seconds = (self.timeForSplit % 3600) % 60
                return cell
            case 2:
                let cell = TitleCell()
                cell.titleLabel.text = "Rest Duration"
                cell.numberTitleLabel.text = String.makeTimeString(seconds: timeForRest, withLetterDescription: true)
                return cell
            // Picker cell
            case 3:
                let cell = TimePickerCell()
                cell.delegate = self
                cell.indexPath = titleRestIndexPath
                cell.isSplitPicker = false
                cell.minutes = (self.timeForRest % 3600) / 60
                cell.seconds = (self.timeForRest % 3600) % 60
                
                return cell
            default:
                return UITableViewCell()
            }
        // The third section
        case 2:
            switch(indexPath.row){
            // Title cell
            case 0:
                let cell = TitleCell()
                cell.titleLabel.text = "Rest Duration"
                cell.numberTitleLabel.text = String.makeTimeString(seconds: timeForRest, withLetterDescription: true)
                return cell
            // Picker cell
            case 1:
                let cell = TimePickerCell()
                cell.delegate = self
                cell.indexPath = titleRestIndexPath
                cell.isSplitPicker = false
                cell.minutes = (self.timeForRest % 3600) / 60
                cell.seconds = (self.timeForRest % 3600) % 60
                
                return cell
            default:
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }
}

extension CustomGoalSettingsViewController: NumberOfSplitsProtocol {
    func retrieveNumberOfSplits(_ numberOfSplits: Int) {
        self.numberOfSplits = numberOfSplits
        print("\(self.numberOfSplits)")
    }
}

extension CustomGoalSettingsViewController: TimePickerDelegate {
    func recieveTime(inSeconds time: Int, fromPickerIndexPath indexPathForTitleCell: IndexPath, isSplitPicker: Bool) {
        // Depends on this value conclude which variable to update
        if isSplitPicker {
            self.timeForSplit = time
        } else {
            self.timeForRest = time
        }
        tableView.reloadRows(at: [indexPathForTitleCell], with: .none)
        
        
    }
}
