//
//  AttentionMessageView.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 8.06.22.
//

import UIKit

enum Attention: String {
    case wrongPassword = "Passwords are not the same."
}

class AttentionMessageView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(rgb: 0x8E5A1D)
        return label
    }()
    
    init(frame: CGRect, _ attention: Attention) {
        self.titleLabel.text = attention.rawValue
        
        super.init(frame: frame)
        configureView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        self.backgroundColor = UIColor(rgb: 0xF4BF4F).withAlphaComponent(0.5)
        self.layer.borderColor = UIColor(rgb: 0xF4BF4F).withAlphaComponent(0.9).cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        
        self.addSubview(titleLabel)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
    }
}
