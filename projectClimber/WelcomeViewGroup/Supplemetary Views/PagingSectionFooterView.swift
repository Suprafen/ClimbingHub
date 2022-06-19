//
//  PagingSectionFooterView.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 19.06.22.
//

import UIKit
import Combine

class PagingSectionFooterView: UICollectionReusableView {
    static let reuseIdentifier = "PagingSectionFooterViewIdentifier"
    
    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.isUserInteractionEnabled = true
        control.currentPageIndicatorTintColor = .systemBlue
        control.pageIndicatorTintColor = .systemBlue.withAlphaComponent(0.2)
        control.translatesAutoresizingMaskIntoConstraints = false
        
        return control
    }()
    
    private var pagingInfoToken: AnyCancellable?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func configure(with numberOfPages: Int) {
        pageControl.numberOfPages = numberOfPages
    }
    
    func subscribeTo(subject: PassthroughSubject<PagingInfo, Never>, for section: Int) {
        pagingInfoToken = subject
            .filter { $0.sectionIndex == section }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] pagingInfo in
                self?.pageControl.currentPage = pagingInfo.currentPage
            }
    }
    
    private func setupView() {
        backgroundColor = .clear
        
        addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        pagingInfoToken?.cancel()
        pagingInfoToken = nil
    }
}
