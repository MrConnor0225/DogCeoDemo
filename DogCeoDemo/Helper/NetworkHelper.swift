//
//  NetworkHelper.swift
//  DogCeoDemo
//
//  Created by Connor on 2023/8/15.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case badUrl
    case badDecode
    case badImage
    case badConection
}

struct NetworkHelper {
    static func getBreedList(with urlString: String) async throws -> [String] {
        let request = URLRequest(url: URL(string: urlString)!)
        let (data, reponse) = try await URLSession.shared.data(for: request)
        guard let reponse = reponse as? HTTPURLResponse,
              (200...299).contains(reponse.statusCode) else { throw NetworkError.badConection }
        let decoder = JSONDecoder()
        guard let breedList = try? decoder.decode(BreedDictionary.self, from: data) else { throw NetworkError.badDecode }
        return Array(breedList.message.keys)
    }
    
    static func getSubBreedList(with urlString: String) async throws -> [String] {
        let request = URLRequest(url: URL(string: urlString)!)
        let (data, reponse) = try await URLSession.shared.data(for: request)
        guard let reponse = reponse as? HTTPURLResponse,
              (200...299).contains(reponse.statusCode) else { throw NetworkError.badConection }
        let decoder = JSONDecoder()
        guard let subBreedList = try? decoder.decode(SubBreedList.self, from: data) else { throw NetworkError.badDecode }
        return subBreedList.message
    }
    
    static func getImageUrl(with urlString: String) async throws -> URL {
        let request = URLRequest(url: URL(string: urlString)!)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse,
              (200...299).contains(response.statusCode) else { throw NetworkError.badConection }
        let decoder = JSONDecoder()
        guard let imageUrl = try? decoder.decode(BreedImage.self, from: data) else {throw NetworkError.badDecode }
        return URL(string: imageUrl.message)!
    }
    
    static func getThumbnail(with url: URL) async throws -> UIImage {
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse,
              (200...299).contains(response.statusCode) else { throw NetworkError.badConection }
        
        let image = UIImage(data: data)
        guard let thumbnail = image else { throw NetworkError.badImage }
        return thumbnail
    }
    
}
