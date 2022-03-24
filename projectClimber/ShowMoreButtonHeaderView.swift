//
//  ShowMoreHeaderView.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 23.03.22.
//

import UIKit

class ShowMoreButtonHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "ShowMoreHeaderView"
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .bottom
        
        return stackView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        
        return label
    }()
    
    let showMoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("Show more", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
//        button.setContentHuggingPriority(.required, for: .horizontal)
       
        return button
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(showMoreButton)
        
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
}
