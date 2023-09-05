//
//  BreedsViewModel.swift
//  DogCeoDemo
//
//  Created by Connor on 2023/8/23.
//

import Foundation
import UIKit

class BreedsViewModel {
    // MARK: - Properties
    var breedModel: BreedsModel?
    
    // MARK: - Public Method
    func randomBreedImages() async -> BreedsModel? {
        let breedName = await getRandomBreedName()
        let subBreedList = await getSubBreedList(breedName: breedName)
        print("DEBUG subBreedList: \(subBreedList)")
        let breedImage = await getRandomImage(breedName: breedName)
        let subBreeds = await getSubBreedImages(breedName: breedName, subBreedList: subBreedList)
        return BreedsModel(breedName: breedName, breedImage: breedImage, subBreeds: subBreeds)
    }
    
    
    // MARK: - Private Method
    @Sendable
    private func getSubBreedImages(breedName: String, subBreedList: [String]) async -> [(String, UIImage)] {
    
        await withTaskGroup(of: (subBreedName: String, image: UIImage).self) { group in
            for subBreed in subBreedList {
                group.addTask {
                    (subBreed, await self.getRandomImage(breedName: breedName, subBreedName: subBreed))
                    
                }
            }
            var subBreedDict = [String: UIImage]()
            for await (name, image) in group {
                subBreedDict[name] = image
            }
            return subBreedDict.map{ ($0, $1) }
        }
        
    }
    
    private func getSubBreedList(breedName: String) async -> [String] {
        var subBreedList: [String] = []
        do {
            let subBreedUrl = "https://dog.ceo/api/breed/\(breedName)/list"
            subBreedList = try await NetworkHelper.getSubBreedList(with: subBreedUrl)
        } catch {
            print("DEBUG GetSubBreedList Error: \(error)")
        }
        return subBreedList
    }
    
    @Sendable
    private func getRandomImage(breedName: String, subBreedName: String? = nil) async -> UIImage {
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
    
    private func getRandomBreedName() async -> String {
        var breedName: String = ""
        do {
            let breedsUrl = "https://dog.ceo/api/breeds/list/all"
            let breedList = try await NetworkHelper.getBreedList(with: breedsUrl)
            breedName = breedList.randomElement()!
        } catch {
            print("DEBUG GetRandomBreedName Error: \(error.localizedDescription)")
        }

        return breedName
    }
    
}
