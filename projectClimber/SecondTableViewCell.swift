//
//  SecondTableViewCell.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 15.02.22.
//

import UIKit

class SecondTableViewCell: UITableViewCell {

    let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        
        return stack
    }()
    
    let totalTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Total time"
        label.textColor = .green
        
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        stack.addArrangedSubview(totalTimeLabel)
        stack.addArrangedSubview(timeLabel)
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(totalTime: Int) {
        totalTimeLabel.text = String.makeTimeString(seconds: totalTime)
    }
}
