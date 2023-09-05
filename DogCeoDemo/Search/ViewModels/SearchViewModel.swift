//
//  SearchViewModel.swift
//  DogCeoDemo
//
//  Created by Connor on 2023/9/4.
//

import Foundation
import UIKit

class SearchViewModel {
    // MARK: - Properties
    var breedModels: [BreedsModel]?
    
    // MARK: - Public Method
    func getSubBreedImages(breedList: [String]) async -> [(String, UIImage)] {
    
        await withTaskGroup(of: (breedName: String, image: UIImage).self ) { group in
            for breed in breedList {
                group.addTask {
                    (breed, await self.getRandomImage(breedName: breed))
                }
            }
            var breedDict = [String: UIImage]()
            for await (name, image) in group {
                breedDict[name] = image
            }
            return breedDict.map{ ($0, $1) }
        }
        
    }
    
    func getRandomImage(breedName: String, subBreedName: String? = nil) async -> UIImage {
        var image = UIImage()
        do {
            let subBreedPath = subBreedName == nil ? "" : "/\( subBreedName!)"
            let imageUrlString = "https://dog.ceo/api/breed/\(breedName)\(subBreedPath)/images/random"
            let imageUrl = try await NetworkHelper.getImageUrl(with: imageUrlString)

            image = try await NetworkHelper.getThumbnail(with: imageUrl)
        } catch {
            if let noImage = UIImage(named: "no_image") {
                image = noImage
            }
            print("DEBUG GetRandomImage Error: \(error)")
        }
        return image
    }
    
    func getBreedList() async -> [String] {
        var breedList: [String] = []
        do {
            let breedsUrl = "https://dog.ceo/api/breeds/list/all"
            breedList = try await NetworkHelper.getBreedList(with: breedsUrl)
            
        } catch {
            print("DEBUG getBreedList Error: \(error.localizedDescription)")
        }
        return breedList
    }
    
}
