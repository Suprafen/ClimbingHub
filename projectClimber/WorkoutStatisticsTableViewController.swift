//
//  WorkoutStatisticsTableViewController.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 15.02.22.
//

import UIKit
// This table view is called when a user tab on the workout and wants to know more about specific workout
class WorkoutStatisticsTableViewController: UITableViewController {

    var workout: Workout?
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        if let workout = workout {
            navigationItem.title = dateFormatter.string(from: workout.date)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let workout = workout {
            switch(indexPath.row) {
            case 0:
                let cell = FirstTableViewCell()
                cell.configure(with: workout)
                cell.selectionStyle = .none
                
                return cell
            case 1:
                let cell = SecondTableViewCell()
                cell.configure(totalTime: workout.totalTime)
                cell.selectionStyle = .none
                
                return cell
            case 2:
                let cell = ThirdTableViewCell()
                guard let timeOnHangBoard = workout.timeOnHangBoard else { return UITableViewCell()}
                cell.configure(with: timeOnHangBoard)
                cell.selectionStyle = .none
                
                return cell
            case 3:
                let cell = FourthTableViewCell()
                cell.configure(with: workout)
                cell.selectionStyle = .none
                
                cell.layoutIfNeeded()
                
                return cell
            default:
                return UITableViewCell()
            }
        } else {
            return UITableViewCell()
        }
    }
    
}
