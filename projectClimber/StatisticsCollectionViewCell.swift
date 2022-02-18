//
//  HistoryCollectionViewCell.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 17.02.22.
//

import UIKit
import RealmSwift

class StatisticsCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "HistoryCollectionCell"
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .leading
       
        return stack
    }()
    
    let totalTimeStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
       
        return stack
    }()
    
    let hangBoardTimeStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
       
        return stack
    }()
    
    let totalTimetitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.text = "Time in general:"
        
        return label
    }()
    
    let hangboardTimetitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.text = "Time on handboard:"
        
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        label.textAlignment = .right
        
        return label
    }()
    
    let timeOnHangboardLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        label.textAlignment = .right
        
        return label
    }()
    
    override init (frame: CGRect) {
        super.init(frame: frame)
         
        totalTimeStackView.addArrangedSubview(totalTimetitleLabel)
        totalTimeStackView.addArrangedSubview(timeLabel)
        
        hangBoardTimeStackView.addArrangedSubview(hangboardTimetitleLabel)
        hangBoardTimeStackView.addArrangedSubview(timeOnHangboardLabel)
        
        stackView.addArrangedSubview(totalTimeStackView)
        stackView.addArrangedSubview(hangBoardTimeStackView)
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError(" init?(coder: NSCoder) has not been implemented")
    }
    
    func configure(with object: Object) {
        guard let statistics = object as? Statistics else { print("Downcasting error in Workout Cell"); return }
        
        timeLabel.text = String.makeTimeString(seconds: statistics.totalWorkoutTime)
        timeOnHangboardLabel.text = String.makeTimeString(seconds: statistics.totalTimeOnHangboard)
    }
}
