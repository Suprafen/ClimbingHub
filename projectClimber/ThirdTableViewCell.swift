//
//  ThirdTableViewCell.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 16.02.22.
//

import UIKit

class ThirdTableViewCell: UITableViewCell {

    let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
       
        return stack
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.text = "Time on HandBoard"
        label.textColor = .magenta
        label.textAlignment = .left
        
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

        stack.addArrangedSubview(titleLabel)
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
    
    func configure(with timeOnHandBoard: Int) {
        timeLabel.text = String.makeTimeString(seconds: timeOnHandBoard)
    }
}
