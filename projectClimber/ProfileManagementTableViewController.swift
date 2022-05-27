//
//  ProfileManagementTableViewController.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 11.05.22.
//

import UIKit
import RealmSwift

protocol ProfileManagementTableViewDelegate {
    func updateTable()
}

class ProfileManagementTableViewController: UITableViewController {

    var userData: User?
    var delegate: ProfileManagementTableViewDelegate?
    
    init(style: UITableView.Style, userData: User?) {
        self.userData = userData
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.delegate!.updateTable()
    }
    // MARK: Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Name"
        case 1:
            return "Email"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        
        switch section {
        case 0:
            let viewToShow = NameChangingTableViewController(style: .insetGrouped, userName: userData!.name)
            viewToShow.delegate = self
            viewToShow.navigationItem.largeTitleDisplayMode = .never
            viewToShow.navigationItem.title = "Change Your Name"
            navigationController?.pushViewController(viewToShow, animated: true)
        case 1:
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = LabelTableCell()
            cell.label.text = userData?.name
            cell.accessoryType = .disclosureIndicator
            
            return cell
            
        case 1:
            let cell = LabelTableCell()
            cell.label.text = userData?.email
            cell.selectionStyle = .none
            
            
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension ProfileManagementTableViewController: NameChangingTableViewDelegate {
    func get(name: String) {
        //TODO: Dispose of exclamation mark
        let userConfiguration = realmApp.currentUser!.configuration(partitionValue: userData!.userID)
        let realm = try! Realm(configuration: userConfiguration)
        
        try! realm.write {
            userData?.name = name
        }
        
        self.tableView.reloadData()
    }
}

// MARK: - Cells
class LabelTableCell: UITableViewCell {
    static let reuseIdentifier = "LableTableCell"
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
}
