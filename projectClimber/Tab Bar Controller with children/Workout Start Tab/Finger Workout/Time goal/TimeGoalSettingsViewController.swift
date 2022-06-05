//
//  WorkoutSettingsViewController.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 1.04.22.
//

import UIKit

protocol TimeGoalSettingsDelegate {
    func getTime(_ time: Int)
}

class TimeGoalSettingsViewController: UIViewController {

    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 15
        
        return stack
    }()
    
    let labelsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 15
        
        return stack
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.text = "Set Time Goal"
        label.contentHuggingPriority(for: .vertical)
        
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.numberOfLines = 2
        label.textColor = .systemGray2
        label.text = "Set time goal and let's start!"
        label.contentHuggingPriority(for: .vertical)
        
        return label
    }()
    
    let textField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 50, height: 200))
        textField.borderStyle = .none
        textField.text = "00:00"
        textField.tintColor = .black
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 50, weight: .semibold)
        textField.keyboardType = .numberPad
        textField.addTarget(nil, action: #selector(timeGoalTextFieldChanged(_:)), for: .editingChanged)
        return textField
    }()
    
    let timePicker: UIPickerView = {
        let timePicker = UIPickerView()
//        timePicker.heightAnchor.constraint(equalToConstant: 400).isActive = true
        return timePicker
    }()
    
    var delegate: TimeGoalSettingsDelegate?
    var minutes: Int = 0
    var seconds: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissButtonTapped))
        
        configureView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
//            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 35),
//            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
//            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
//            subTitleLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            
//            stackView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 15),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 35),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15)
        ])
    }
    
    //MARK: Helper methods
    func configureView() {
        self.view.backgroundColor = .white
        
        self.timePicker.delegate = self
        self.timePicker.dataSource = self
        
        self.timePicker.selectRow(self.minutes, inComponent: 0, animated: true)
        self.timePicker.selectRow(self.seconds, inComponent: 1, animated: true)
        
        stackView.addArrangedSubview(titleLabel)
//        stackView.addArrangedSubview(subTitleLabel)
        stackView.addArrangedSubview(timePicker)
        
//        self.view.addSubview(titleLabel)
//        self.view.addSubview(subTitleLabel)
        self.view.addSubview(stackView)
        
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
//        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func retrieveTime(_ time: Int) {
        delegate?.getTime(time)
    }
    
    //MARK: Selectors
    @objc func dismissButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func timeGoalTextFieldChanged(_ sender: UITextField) {
        guard var textFieldString = sender.text else { return }
        let letterToTheBack = textFieldString[textFieldString.startIndex]
        if textFieldString.count < 5 {
            textFieldString.remove(at: textFieldString.startIndex)
            textFieldString.insert(contentsOf: [letterToTheBack], at: textFieldString.endIndex)
        } else {
            textFieldString.removeLast()
        }
        sender.text = textFieldString
    }
}

extension TimeGoalSettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0,1:
            return 60
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width/2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row) min"
        case 1:
            return "\(row) Sec"
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            if row == 0 {
                pickerView.selectRow(row + 1, inComponent: 0, animated: true)
                minutes = 1
            } else {
                minutes = row
            }
            
        case 1:
//            if row == 0 {
//                pickerView.selectRow(row + 1, inComponent: 0, animated: true)
//                seconds = 1
//            } else {
                seconds = row
//            }
        default:
            break
        }
        retrieveTime((minutes * 60) + seconds)
        print("Seconds \((minutes * 60) + seconds)")
    }
}
