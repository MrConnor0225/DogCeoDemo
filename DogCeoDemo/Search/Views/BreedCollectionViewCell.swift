//
//  BreedCollectionViewCell.swift
//  DogCeoDemo
//
//  Created by Connor on 2023/8/18.
//

import UIKit

class BreedCollectionViewCell: UICollectionViewCell {
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
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    
    func bindingData(with model: BreedsModel) {
        Task.detached { @MainActor in
            self.breedNameLabel.text = model.breedName.capitalized
            self.breedImageView.image = model.breedImage
        }
    }
}
