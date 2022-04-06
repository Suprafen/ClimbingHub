//
//  NumberOfSplitsStaticCell.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 5.04.22.
//

import UIKit

protocol NumberOfSplitsProtocol {
    func retrieveNumberOfSplits(_ numberOfSplits: Int)
}

class NumberOfSplitsStaticCell: UITableViewCell {

    let stepperAndNumberOfSplitsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        
        return stack
    }()
    
    let outerMostStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.alignment = .center
        
        return stack
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Splits"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        return label
    }()
    
    let numberOfSplitsLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        return label
    }()
    
    let numberOfSplitsStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.stepValue = 1
        stepper.minimumValue = 1
        stepper.maximumValue = 20
        stepper.addTarget(nil, action: #selector(stepperChangedValue), for: .touchUpInside)
        
        return stepper
    }()
    
    var delegate: NumberOfSplitsProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        contentView.addSubview(numberOfSplitsLabel)
        contentView.addSubview(numberOfSplitsStepper)

        contentView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfSplitsLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfSplitsStepper.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            
            numberOfSplitsStepper.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            numberOfSplitsStepper.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            numberOfSplitsLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            numberOfSplitsLabel.trailingAnchor.constraint(equalTo: numberOfSplitsStepper.leadingAnchor, constant: -15),
            numberOfSplitsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        ])
    }

    //MARK: Helper methods
    func configureView() {
    }
    
    //MARK: Selectors
    @objc func stepperChangedValue(_ sender: UIStepper) {
        self.numberOfSplitsLabel.text = "\(Int(sender.value))"
        delegate?.retrieveNumberOfSplits(Int(sender.value))
    }
}
