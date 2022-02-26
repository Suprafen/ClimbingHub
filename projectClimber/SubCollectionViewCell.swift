//
//  SubCollectionViewCell.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 25.02.22.
//

import UIKit
import RealmSwift

class SubCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "SubCollectionViewCell"
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .center
       
        return stack
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.text = "Time: "
        
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        label.textAlignment = .right
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(timeLabel)
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError(" init?(coder: NSCoder) has not been implemented")
    }
    
    func configure(with object: Object) {
        guard let statistics = object as? Statistics else { print("Downcasting error in Workout Cell"); return }
        titleLabel.text = statistics.titleStatistics
        timeLabel.text = String.makeTimeString(seconds: statistics.time)
    }
}
