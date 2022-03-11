//
//  HistoryCollectionViewCell.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 17.02.22.
//

import UIKit
import RealmSwift

class StatisticsCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "StatisticsCollectionViewCell"
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .trailing
        
        return stack
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textAlignment = .right
        label.text = "Time: "
        
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 70, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.textAlignment = .right
        label.textColor = UIColor.systemBlue.withAlphaComponent(0.3)
        
        return label
    }()

    override init (frame: CGRect) {
        super.init(frame: frame)
        
        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(titleLabel)
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError(" init?(coder: NSCoder) has not been implemented")
    }
    
    //MARK: Helper methods
    func configure(with object: Object) {
        guard let statistics = object as? Statistics else { print("Downcasting error in Workout Cell"); return }
        titleLabel.text = statistics.titleStatistics
        timeLabel.text = String.makeTimeString(seconds: statistics.time, withLetterDescription: false)
    }
}
