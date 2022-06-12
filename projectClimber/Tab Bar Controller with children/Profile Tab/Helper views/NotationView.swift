//
//  NotationViewController.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 17.05.22.
//

import UIKit

class NotationView: UIView {

    let outerMostStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.distribution = .fill
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    let firstLabelStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIFont.labelFontSize, weight: .medium)
        label.text = "You will lose your data"
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .light)
        label.textColor = .gray
        label.text = "Here goes text that makes clear user is going to lose their data and so on. "
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return imageView
    }()
    
    var titleText: String
    var descriptionText: String
    var image: UIImage
    
    init(frame: CGRect, titleText: String, descriptionText: String, image: UIImage = UIImage(systemName: "")!) {
        self.titleText = titleText
        self.descriptionText = descriptionText
        self.image = image
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        self.backgroundColor = .white
        
        let size: CGFloat = UIScreen.main.bounds.height - 10
        let imageSize: CGFloat = size / 17
        
        titleLabel.text = titleText
        descriptionLabel.text = descriptionText
        iconImageView.image = image
        
        self.firstLabelStack.addArrangedSubview(titleLabel)
        self.firstLabelStack.addArrangedSubview(descriptionLabel)
        
        self.outerMostStack.addArrangedSubview(iconImageView)
        self.outerMostStack.addArrangedSubview(firstLabelStack)
        self.addSubview(outerMostStack)

//        iconImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.1, constant: 0).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        NSLayoutConstraint.activate([
            outerMostStack.topAnchor.constraint(equalTo: self.topAnchor),
            outerMostStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            outerMostStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            outerMostStack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
