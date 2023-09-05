//
//  BreedTableViewCell.swift
//  DogCeoDemo
//
//  Created by Connor on 2023/8/15.
//

import Foundation
import UIKit

class BreedTableViewCell: UITableViewCell {
    // MARK: - Properties
   
    private var breedNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 20)
        return lbl
    }()
    
    private lazy var breedImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "no_image")
        iv.setDimensions(height: 50, width: 50)
        iv.layer.cornerRadius = 15
        iv.clipsToBounds = true
        return iv
    }()
    
    private var downloadTask: URLSessionDownloadTask?

    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        breedNameLabel.text = "loading ..."
        breedImageView.image = UIImage(named: "no_image")
    }
    
    // MARK: - Helper
    func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [breedImageView, breedNameLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 30
        contentView.addSubview(stackView)
        stackView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: -5, paddingRight: -5)
    }
    
    func bindingData(subBreedName: String, image: UIImage) {
        Task.detached { @MainActor in
            self.breedNameLabel.text = subBreedName.capitalized
            self.breedImageView.image = image
        }
    }
}
