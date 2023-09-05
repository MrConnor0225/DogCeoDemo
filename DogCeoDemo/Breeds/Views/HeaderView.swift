//
//  HeaderView.swift
//  DogCeoDemo
//
//  Created by Connor on 2023/8/18.
//

import UIKit

class HeaderView: UIView {
    // MARK: - Properties
    let headerLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        lbl.textColor = .white
        lbl.text = "SubBreed List"
        return lbl
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func setupUI() {
        
        addSubview(headerLabel)
        headerLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: -5, paddingRight: -5)
        backgroundColor = .systemGray
    }
}
