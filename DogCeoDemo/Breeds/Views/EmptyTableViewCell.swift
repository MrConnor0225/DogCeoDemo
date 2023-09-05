//
//  EmptyTableViewCell.swift
//  DogCeoDemo
//
//  Created by Connor on 2023/8/18.
//

import UIKit

class EmptyTableViewCell: UITableViewCell {
    // MARK: - Properties
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        
        lbl.text = "No SubBreed List"
        lbl.textColor = UIColor(hexString: "BABABA")
        lbl.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        return lbl
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Helper
    private func setupUI() {
        contentView.addSubview(titleLabel)
        titleLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 150)
    }
    
}

