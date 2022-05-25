//
//  ProfileSettingsTableViewController.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 2.05.22.
//

import UIKit
import SafariServices

class ProfileSettingsTableViewController: UITableViewController {
    
    var userData: User?
    
    init(style: UITableView.Style, userData: User?) {
        self.userData = userData
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        switch section {
        case 0:
            let cell = ProfileTableCell()
            cell.nameLabel.text = self.userData?.name ?? "_local_realm_without_name"
            cell.descriptionLabel.text = "Personal info, Account management"
            cell.accessoryType = .disclosureIndicator
            
            return cell
        case 1:
            switch (indexPath.row) {
            case 0:
                let cell = PrivacyTableCell()
                let image = UIImage(systemName: "hand.raised.fill")!
                cell.configureCell(name: "Privacy Policy", image: image, color: .systemBlue)
                cell.separatorInset = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 0)
                cell.accessoryType = .disclosureIndicator
                
                return cell
                
            case 1:
                let cell = PrivacyTableCell()
                let image = UIImage(systemName: "trash.fill")!
                cell.configureCell(name: "Delete Account", image: image, color: .systemRed)
                cell.separatorInset = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 0)
                cell.accessoryType = .disclosureIndicator
                
                return cell
            default:
                return UITableViewCell()
            }
        case 2:
            let cell = LogoutTableCell()
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = indexPath.section
        switch section {
            // Profile
        case 0:
            switch indexPath.row {
            case 0:
                let viewToShow = ProfileManagementTableViewController(style: .insetGrouped, userData: self.userData)
                viewToShow.delegate = self
                viewToShow.navigationItem.largeTitleDisplayMode = .never
                viewToShow.navigationItem.title = "Profile Management"
                navigationController?.pushViewController(viewToShow, animated: true)
            default:
                print()
            }
            // Main functionality in the settings
        case 1:
            switch indexPath.row {
            case 0:
                let privacyPolicyStringURL = "https://johny77.notion.site/ClimbingHub-Main-page-8882b7030b5645ba8cdfc9af7e6d6efa"
                if let url = URL(string: privacyPolicyStringURL) {
                    let safariController = SFSafariViewController(url: url)
                    present(safariController, animated: true)
                }
            case 1:
                let viewToShow = DeleteAccountViewController()
                viewToShow.navigationItem.largeTitleDisplayMode = .never
                viewToShow.navigationItem.title = "Delete Account"
                viewToShow.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(viewToShow, animated: true)
            default:
                print()
            }
            // Logout
        case 2:
            switch indexPath.row {
            case 0:
                if app.currentUser != nil{
                    presentAlertController(withMessage: "You can always access your content by signing back in")
                } else {
                    returnToStartScreen()
                }
            default:
                print()
            }
        default:
            print()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // MARK: - Helper methods
    
    func presentAlertController(withMessage message: String) {
        let alertController = UIAlertController(title: "Sign Out?", message: message, preferredStyle: .alert)
        
        let logoutAction = UIAlertAction(title: "Sign Out", style: .destructive) { _ in
            self.logout()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(logoutAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }

    
    func configureView() {
        self.view.backgroundColor = .systemGray6
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Profile"
        
        
    }
    
    func logout() {
        // Perform logout if user has been loged in
        app.currentUser!.logOut { (_) in
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }
    }
    
    func returnToStartScreen() {
        self.dismiss(animated: true)
    }
}

extension ProfileSettingsTableViewController:ProfileManagementTableViewDelegate {
    func updateTable() {
        self.tableView.reloadData()
    }
}

//MARK: - Cells
class ProfileTableCell: UITableViewCell {
    static let reuseIdentifier = "ProfileTableCell"
    
    let outermostStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = 15
        
        return stack
    }()
    
    let labelStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        stack.spacing = 15
        stack.contentHuggingPriority(for: .horizontal)
        
        return stack
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.4
        
        return label
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        labelStack.addArrangedSubview(nameLabel)
        labelStack.addArrangedSubview(descriptionLabel)
        
        outermostStackView.addArrangedSubview(circle)
        outermostStackView.addArrangedSubview(labelStack)

        contentView.addSubview(outermostStackView)
        
        outermostStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            outermostStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            outermostStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            outermostStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            outermostStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
    
    func configure(with name: String) {
        nameLabel.text = name
    }
}

class LogoutTableCell: UITableViewCell {
    static let reuseIdentifier = "LogoutTableCell"
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Log Out"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
}

class PrivacyTableCell: UITableViewCell {
    static let reuseIdentifier = "PrivacyTableCell"

    let iconContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        view.widthAnchor.constraint(equalToConstant: 30).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .label
        
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 30
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        
        return stackView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        iconContainer.addSubview(iconImageView)
        iconImageView.center = iconContainer.center
        
        contentView.addSubview(iconContainer)
        contentView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // To dispose of error about ambiguous cell's height
        // I just added spacing for title and centered iconContainer by title
        NSLayoutConstraint.activate([
            iconContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            iconContainer.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            titleLabel.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconContainer.backgroundColor = nil
        iconImageView.image = nil
        titleLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.clipsToBounds = true
        
        let size: CGFloat = contentView.frame.size.height - 12
        
        let imageSize: CGFloat = size / 1.5
        iconImageView.frame = CGRect(x: (30 - imageSize) / 2, y: (30 - imageSize) / 2, width: imageSize, height: imageSize)
    }
    
    //MARK: Helper methods
    func configureCell(name: String, image: UIImage, color: UIColor) {
        titleLabel.text = name
        self.iconContainer.backgroundColor = color
        self.iconImageView.image = image
    }
}
