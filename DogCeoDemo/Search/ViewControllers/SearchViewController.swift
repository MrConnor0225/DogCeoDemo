//
//  SearchViewControllerile.swift
//  DogCeoDemo
//
//  Created by Connor on 2023/8/18.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    // MARK: - Properties
    private lazy var searchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundColor = .white
        searchBar.delegate = self
        return searchBar
    }()
    private lazy var collectionView: UICollectionView = {
        let frame = CGRect(x: 0, y: 0, width: .zero, height: .zero)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width, height: 70)
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .systemGray
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BreedCollectionViewCell.self, forCellWithReuseIdentifier: BreedCollectionViewCell.className)
        return collectionView
    }()
    private var task: Task<Void, Never>?
    private let viewModel = SearchViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Helper
    func setupUI() {
        let backButton = UIBarButtonItem(title: "← Back", style: .plain, target: self, action: #selector(handleBack))
        backButton.tintColor = .white
        navigationItem.leftBarButtonItem = backButton
        
        view.addSubview(searchBar)
        searchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        view.addSubview(collectionView)
        collectionView.anchor(top: searchBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
    // MARK: - Actions
    @objc
    func handleBack() {
        self.navigationController?.popViewController(animated: true)
    }

}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        task?.cancel()
        task = Task {
            let breeds = await viewModel.getBreedList()
            let filterBreeds = breeds.filter { $0.lowercased().contains(searchText.lowercased()) }
            var dataArray = await viewModel.getSubBreedImages(breedList: filterBreeds)
            await MainActor.run {
                var dogModels = [BreedsModel]()
                dataArray.sort { $0.0 < $1.0 }
                for data in dataArray {
                    dogModels.append(BreedsModel(breedName: data.0, breedImage: data.1))
                }
                self.viewModel.breedModels = dogModels
                self.collectionView.reloadData()
           }
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let models = self.viewModel.breedModels else { return 0 }
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let models = self.viewModel.breedModels, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BreedCollectionViewCell.className, for: indexPath) as? BreedCollectionViewCell else { return UICollectionViewCell() }
        cell.bindingData(with: models[indexPath.row])
        return cell
        
    }
    
}
