//
//  BreedsViewController.swift
//  DogCeoDemo
//
//  Created by Connor on 2023/8/16.
//

import UIKit

class BreedsViewController: UIViewController {
    // MARK: - Properties
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
        lbl.text = "Breed: Unknown"
        lbl.textColor = .red
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let breedImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "no_image")
        iv.contentMode = .scaleAspectFit
        iv.setDimensions(height: 200, width: 200)
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var randomButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Get Random Breed", for: .normal)
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(handleGetRandom), for: .touchUpInside)
        btn.setDimensions(height: 40, width: 220)
        btn.backgroundColor = UIColor(hexString: "CC8500")
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return btn
    }()
    
    private lazy var subBreedTableView = {
        let tableView = UITableView()
        tableView.sectionHeaderTopPadding = 0
        tableView.separatorColor = UIColor(hexString: "737373")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BreedTableViewCell.self, forCellReuseIdentifier: BreedTableViewCell.className)
        tableView.register(EmptyTableViewCell.self, forCellReuseIdentifier: EmptyTableViewCell.className)
        return tableView
    }()
    
    var breedViewModel = BreedsViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    // MARK: - Helpers
    func setupUI() {
        setNavigationStyle()
        view.backgroundColor = .white
        navigationItem.title = "Random Breed"
        let rightButton = UIBarButtonItem(title: "Search", style: .done, target: self, action: #selector(handleSearch))
        rightButton.tintColor = .white
        navigationItem.rightBarButtonItem = rightButton
        let stackView = UIStackView(arrangedSubviews: [titleLabel, breedImageView, randomButton])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        view.addSubview(stackView)
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 40, paddingRight: -40)
        
        // TableView
        view.addSubview(subBreedTableView)
        subBreedTableView.anchor(top: stackView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 10)
    }
    
    @objc
    func handleGetRandom() {
        Task.detached { @MainActor in
            guard let model = await self.breedViewModel.randomBreedImages() else { return }
            self.breedViewModel.breedModel = model
            
            self.titleLabel.text = "Breed Name: \(model.breedName.capitalized)"
            self.breedImageView.image = model.breedImage
            self.subBreedTableView.reloadData()
        }
    }
    
    @objc
    func handleSearch() {
        self.navigationController?.pushViewController(SearchViewController(), animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension BreedsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let model = self.breedViewModel.breedModel {
            tableView.separatorStyle = model.subBreeds.isEmpty ? .none : .singleLine
        } else {
            tableView.separatorStyle = .none
        }
        
        return HeaderView()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = self.breedViewModel.breedModel
               else { return 1 }
        return model.subBreeds.isEmpty ? 1 : model.subBreeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let model = self.breedViewModel.breedModel, !model.subBreeds.isEmpty,
              let cell = tableView.dequeueReusableCell(withIdentifier: BreedTableViewCell.className, for: indexPath) as? BreedTableViewCell else { return EmptyTableViewCell() }
        
        let (subBreed, image) = model.subBreeds[indexPath.row]
        cell.bindingData(subBreedName: subBreed, image: image)
        
        return cell
    }
}
