//
//  SplitTableViewCell.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 20.03.22.
//

import UIKit

class SplitTableViewCell: UITableViewCell {
    static let reuseIdentifier = "SplitCellIdentifier"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Title"
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 17, weight: .medium)
        label.textColor = .white
        
        return label
    }()
    
    let timeLabel:  UILabel = {
        let label = UILabel()
        label.text = "Time"
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .white
        
        return label
    }()
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        addSubview(titleLabel)
        addSubview(timeLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            timeLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 50),
            timeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    func configure(cellWithNumber number: Int, with time: Int, isLongestSplit: Bool) {
        
        titleLabel.text = "Split \(number)"
        timeLabel.text = String.makeTimeString(seconds: time, withLetterDescription: false)
        if isLongestSplit {
            timeLabel.text! += " 🏆"
        }
    }
}
