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
    
    //MARK: Total stats
    let totalTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textAlignment = .left
        label.textColor = .white
        label.text = "💪Workouts done so far"
        
        return label
    }()
    
    let totalWorkoutsQuantityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 43, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.textAlignment = .left
        label.textColor = .white
        
        return label
    }()
    
    let totalDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.textAlignment = .left
        label.textColor = .white
        
        return label
    }()

    //MARK: Hangboard stats
    let hangboardTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.textAlignment = .left
        label.textColor = .white
        label.text = "🏆Your best attempt on hangboard"
        
        return label
    }()
    
    let longestHangboardTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 43, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.textAlignment = .left
        label.textColor = .white
        
        return label
    }()
    
    let hangboardDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.textAlignment = .left
        label.textColor = .white
        
        return label
    }()
    //MARK: Variables
    var statisticsObject: Statistics!
    let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = .current
        
        return calendar
    }()
    
    //MARK: Initializers
    override init (frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(totalTitleLabel)
        addSubview(totalDescriptionLabel)
        addSubview(totalWorkoutsQuantityLabel)

        addSubview(longestHangboardTimeLabel)
        addSubview(hangboardDescription)
        addSubview(hangboardTitleLabel)

        // Total stat....
        totalTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        totalDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        totalWorkoutsQuantityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Hangboard stat ...
        hangboardTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        longestHangboardTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        hangboardDescription.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            totalWorkoutsQuantityLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            totalWorkoutsQuantityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            totalWorkoutsQuantityLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            totalTitleLabel.topAnchor.constraint(equalTo: totalWorkoutsQuantityLabel.bottomAnchor, constant: 20),
            totalTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            totalTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            totalDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            totalDescriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            totalDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            hangboardTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            hangboardTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            hangboardTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            longestHangboardTimeLabel.topAnchor.constraint(equalTo: hangboardTitleLabel.bottomAnchor, constant: 30),
            longestHangboardTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            longestHangboardTimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            hangboardDescription.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            hangboardDescription.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            hangboardDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError(" init?(coder: NSCoder) has not been implemented")
    }
    
    //MARK: Helper methods
    func configure(with object: Object, quantityOfWorkouts: Int? = nil, longestAttemptOnHangboard: Int? = nil) {
        // Just for avoiding disappearing particular elements of the cell, when it's configured
        hangboardDescription.isHidden = false
        longestHangboardTimeLabel.isHidden = false
        hangboardTitleLabel.isHidden = false
        totalTitleLabel.isHidden = false
        totalDescriptionLabel.isHidden = false
        totalWorkoutsQuantityLabel.isHidden = false
        
        guard let statistics = object as? Statistics else { return }
        
        if statistics.type == .totalTime {
            hangboardDescription.isHidden = true
            longestHangboardTimeLabel.isHidden = true
            hangboardTitleLabel.isHidden = true
            
            totalDescriptionLabel.text = "You've been working out for \(String.makeTimeString(seconds: statistics.time, withLetterDescription: true))"
            totalWorkoutsQuantityLabel.text = quantityOfWorkouts != nil ? String(quantityOfWorkouts!) : ""
        } else if statistics.type == .hangBoard {
            totalTitleLabel.isHidden = true
            totalDescriptionLabel.isHidden = true
            totalWorkoutsQuantityLabel.isHidden = true
            
            hangboardDescription.text = "You've been on hangboard for \(String.makeTimeString(seconds: statistics.time, withLetterDescription: true))"
            longestHangboardTimeLabel.text = longestAttemptOnHangboard != nil ? String.makeTimeString(seconds: longestAttemptOnHangboard!, withLetterDescription: true) : ""
        }
    }
}
