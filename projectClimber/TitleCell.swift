//
//  TitleCell.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 5.04.22.
//

import UIKit

class TitleCell: UITableViewCell {

    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Duraion of split"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        return label
    }()
    
    let numberTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "13m 22s"
        
        return label
    }()
    
    var timeForNumberTitle = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(numberTitleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        numberTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            
            numberTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            numberTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            numberTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
        ])
    }
}
