//
//  UIImage.swift
//  FetchDogImage
//
//  Created by Connor on 2023/8/24.
//

import UIKit

extension UIImage {
    var thumbnail: UIImage? {
        get async {
            let size = CGSize(width: 40, height: 40)
            return await self.byPrepareingThumbnail(of: size)
        }
    }
}
