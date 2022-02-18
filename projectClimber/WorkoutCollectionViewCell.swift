//
//  WorkoutCollectionViewCell.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 4.02.22.
//

import UIKit
import RealmSwift

class WorkoutCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "Cell"
    
    let labelsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 10
        
        return stack
    }()
    
    let workoutTitleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        
        return label
    }()
    
    let dateLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .light)
        label.textAlignment = .left
        label.textColor = .black
        
        return label
    }()
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        return dateFormatter
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        labelsStackView.addArrangedSubview(workoutTitleLabel)
        labelsStackView.addArrangedSubview(dateLabel)
        
        addSubview(labelsStackView)
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: topAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError(" init?(coder: NSCoder) has not been implemented")
    }
    
    //using Object type from Realm
    func configure(with object: Object) {
        // Downcasting to FingerWorkout
        guard let workout = object as? Workout else { print("Downcasting error in Workout Cell"); return }
        
        workoutTitleLabel.text = workout.type.rawValue
        dateLabel.text = dateFormatter.string(from: workout.date)
    }
}
