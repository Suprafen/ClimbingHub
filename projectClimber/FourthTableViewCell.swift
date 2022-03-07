//
//  FourthTableViewCell.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 4.03.22.
//

import UIKit

class FourthTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
   
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "Splits"
        label.textColor = .systemOrange
        label.textAlignment = .left
        
        return label
    }()
    
    let tableView = UITableView()
    
    //MARK: Table View
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        splits.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SplitCell.reuseIdentifier, for: indexPath) as! SplitCell
        print("TABLE CELL CONFIGURED")
        cell.configure(cellWithNumber: indexPath.row + 1, with: splits[indexPath.row])

         tableView.reloadRows(at: [indexPath], with: .none)
        return cell
    }
    
    var splits: [Int] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        tableView.dataSource = self
        tableView.delegate = self
        //TEST
        tableView.backgroundColor = .orange
        
        tableView.register(SplitCell.self, forCellReuseIdentifier: SplitCell.reuseIdentifier)
        
        addSubview(titleLabel)
        addSubview(tableView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        
        
    }

    func configure(with workout: Workout) {
        print("Configure func, workout's splits \(workout.splits.count)")
        for item in workout.splits {
            self.splits.append(item)
        }
    }
}

//MARK: Split Cell
class SplitCell: UITableViewCell {
    static let reuseIdentifier = "SplitCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        return label
    }()
    
    let timeLabel:  UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        addSubview(titleLabel)
        addSubview(timeLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            timeLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 50),
            timeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    func configure(cellWithNumber number: Int, with time: Int) {
        titleLabel.text = "Split #\(number)"
        timeLabel.text = String.makeTimeString(seconds: time)
    }
}
