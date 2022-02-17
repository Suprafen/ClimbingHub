//
//  HistoryCollectionViewCell.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 17.02.22.
//

import UIKit
import RealmSwift

class HistoryCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "HistoryCollectionCell"
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .leading
       
        return stack
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        label.text = "Total time on handboard"
        
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        
        return label
    }()
    
    override init (frame: CGRect) {
        super.init(frame: frame)
         
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(timeLabel)
        
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
    
    func configure(with workout: Object) {
        guard let workout = workout as? History else { print("Downcasting error in Workout Cell"); return }
        
        timeLabel.text = String.makeTimeString(seconds: workout.totalTime)
    }
}
