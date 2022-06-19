//
//  WelcomeViewReasonCollectionViewCell.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 18.06.22.
//
// TODO: Add image view higher than title. It could be SFSymbol, but big one
import UIKit

class WelcomeViewReasonCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "WelcomeViewReasonCollectionViewCellIdentifier"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIFont.labelFontSize, weight: .regular)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let size: CGFloat = UIScreen.main.bounds.height - 10
        let imageSize: CGFloat = size / 17
        
        imageView.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -15),

            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError(" init?(coder: NSCoder) has not been implemented")
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        descriptionLabel.text = nil
        iconImageView.image = nil
    }
    
    func configure(with item: WelcomeReason) {
        titleLabel.text = item.title
        descriptionLabel.text = item.description
        iconImageView.image = UIImage(systemName: item.systemNameForImage)
    }
}
