//
//  WorkoutCollectionViewCell.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 4.02.22.
//

import UIKit
import RealmSwift
import SwiftUI

class WorkoutCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "WorkoutViewCell"
    
    let labelsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .leading
        stack.spacing = 5
        
        return stack
    }()
    
    let workoutTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .black
        label.textAlignment = .left
        
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.4
        label.textColor = .darkGray
        label.textAlignment = .left
        
        return label
    }()
    
    let dateLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.4
        label.textAlignment = .left
        label.textColor = .gray
        
        return label
    }()
    
    let chevronImage: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "chevron.right"), highlightedImage: .none)
        image.tintColor = .gray
        return image
    }()
    
    let insideCirlceImage: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "infinity"))
        
        return image
    }()
    
    let circle: UIView = {
        
        let circleDiameter = UIScreen.main.bounds.height / 13

        let view = UIView(frame: CGRect(x: 0, y: 0, width: circleDiameter, height: circleDiameter))
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = view.frame.height / 2
        view.clipsToBounds = true
        view.alpha = 0.2
        
        view.widthAnchor.constraint(equalToConstant: circleDiameter).isActive = true
        view.heightAnchor.constraint(equalToConstant: circleDiameter).isActive = true
        
        return view
    }()
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        return dateFormatter
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        labelsStackView.addArrangedSubview(dateLabel)
        labelsStackView.addArrangedSubview(timeLabel)
        labelsStackView.addArrangedSubview(workoutTitleLabel)
        
        addSubview(insideCirlceImage)
        
        addSubview(circle)
        addSubview(labelsStackView)
        addSubview(chevronImage)
        
        insideCirlceImage.translatesAutoresizingMaskIntoConstraints = false
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        chevronImage.translatesAutoresizingMaskIntoConstraints = false
        circle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            circle.centerYAnchor.constraint(equalTo: centerYAnchor),
            circle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            circle.trailingAnchor.constraint(equalTo: labelsStackView.leadingAnchor, constant: -20),
            
            insideCirlceImage.centerXAnchor.constraint(equalTo: circle.centerXAnchor),
            insideCirlceImage.centerYAnchor.constraint(equalTo: circle.centerYAnchor),
            
            labelsStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            labelsStackView.trailingAnchor.constraint(equalTo: chevronImage.leadingAnchor, constant: -10),
            labelsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),

            chevronImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError(" init?(coder: NSCoder) has not been implemented")
    }
    
    func configure(with object: Object) {
        // Downcasting to FingerWorkout
        guard let workout = object as? Workout else { return }
        
        workoutTitleLabel.text = workout.type.rawValue
        dateLabel.text = dateFormatter.string(from: workout.date)
        timeLabel.text = String.makeTimeString(seconds: workout.totalTime, withLetterDescription: true)
        switch workout.goalType {
        case .openGoal:
            self.circle.backgroundColor = .systemBlue
            self.insideCirlceImage.tintColor = .systemBlue
            self.insideCirlceImage.image = UIImage(systemName: "infinity")
        case .time:
            self.circle.backgroundColor = UIColor(rgb: 0xF4BF4F)
            self.insideCirlceImage.tintColor = UIColor(rgb: 0xF4BF4F)
            self.insideCirlceImage.image = UIImage(systemName: "timer")
        case .custom:
            self.circle.backgroundColor = UIColor(rgb: 0xEC6A5E)
            self.insideCirlceImage.tintColor = UIColor(rgb: 0xEC6A5E)
            self.insideCirlceImage.image = UIImage(systemName: "wrench")
        }
    }
}
