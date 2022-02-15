//
//  WorkoutStatisticsTableViewController.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 15.02.22.
//

import UIKit

class WorkoutStatisticsTableViewController: UITableViewController {

    var workout: FingerWorkout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let workout = workout {
            switch(indexPath.row) {
            case 0: let cell = FirstTableViewCell()
                cell.configure(with: workout.date)
                return cell
            case 1: let cell = SecondTableViewCell()
                cell.configure(totalTime: workout.totalTime)
                return cell
            default:
                return UITableViewCell()
            }
        } else {
            return UITableViewCell()
        }
    }
}
