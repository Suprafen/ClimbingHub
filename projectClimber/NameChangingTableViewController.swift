//
//  NameChangingTableViewController.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 11.05.22.
//

import UIKit

protocol NameChangingTableViewDelegate {
    func get(name: String)
}

class NameChangingTableViewController: UITableViewController {
    var userName: String
    var delegate: NameChangingTableViewDelegate?
    
//    var isDoneButtonAvailable: Bool {
//        get {
//            return navigationItem.rightBarButtonItem!.isEnabled
//        } set {
//            self.isDoneButtonAvailable = newValue
//        }
//    }
    
    init(style: UITableView.Style, userName: String) {
        self.userName = userName
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NameChangingTableViewCell()
        cell.textField.text = userName
        cell.startedTextFieldText = userName
        cell.selectionStyle = .none
        cell.delegate = self
        
        return cell
    }
    
    // MARK: Selectors
    @objc func doneButtonTapped() {
        // Send userName to the delegate and pop view controller
        delegate?.get(name: userName)
        navigationController?.popViewController(animated: true)
    }
}

extension NameChangingTableViewController: NameChangingTableViewCellDelegate {
    func retreiveTextFieldState(_ name: String?, _ whetherNewName: Bool) {
        // We need to ensure that name was changed and new one is not empty
        guard !name!.isEmpty else {
            navigationItem.rightBarButtonItem!.isEnabled = false
            return
        }
        guard !whetherNewName else {
            navigationItem.rightBarButtonItem!.isEnabled = false
            return
        }
        // If everything is OK so asign name
        self.userName = name!
        navigationItem.rightBarButtonItem!.isEnabled = true
    }
}
// MARK: - Cells

protocol NameChangingTableViewCellDelegate {
    func retreiveTextFieldState(_ name: String?, _ whetherNewName: Bool)
}

class NameChangingTableViewCell: UITableViewCell {
    static let reuseIdentifier = "NameChangingTableViewCell"
    let textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.placeholder = "Your Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(nil, action: #selector(textFieldValueChanged), for: .editingChanged)
        
        return textField
    }()
    var startedTextFieldText: String?
    
    var delegate: NameChangingTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        contentView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
    // MARK: Helper methods
    
    // MARK: Selectors
    @objc func textFieldValueChanged() {
        // Send text field's text and a bool whether something has been changed in the given name
        delegate?.retreiveTextFieldState(self.textField.text,
                                         self.startedTextFieldText == self.textField.text)
    }
}
