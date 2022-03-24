//
//  SectionHeaderWorkoutsHistoryView.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 24.03.22.
//

import UIKit

class SectionHeaderWorkoutsHistoryView: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeaderWorkoutsHistoryView"
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .leading
        
        return stack
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "PLACEHOLDER"
        label.textColor = .label
        
        return label
    }()
    
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        
        return view
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        stackView.addArrangedSubview(titleLabel)
        
        self.addSubview(backgroundView)
        
        addSubview(stackView)
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
