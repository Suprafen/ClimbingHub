//
//  WorkoutCollectionViewCell.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 4.02.22.
//

import UIKit
import RealmSwift

class WorkoutCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "WorkoutViewCell"
    
    let labelsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = 10
        
        return stack
    }()
    
    let workoutTitleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
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
    
    let chevronImage: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "chevron.right"), highlightedImage: .none)
        
        return image
    }()
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        return dateFormatter
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        labelsStackView.addArrangedSubview(workoutTitleLabel)
        labelsStackView.addArrangedSubview(dateLabel)
        
        addSubview(labelsStackView)
        addSubview(chevronImage)
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        chevronImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: topAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            labelsStackView.trailingAnchor.constraint(equalTo: chevronImage.leadingAnchor, constant: -10),
            labelsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            chevronImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
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
