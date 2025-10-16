//
//  ImageManager.swift
//  Adhder
//
//  Created by Phillip Thelen on 02.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import UIKit
import Kingfisher

class ImageManager {
    static var kingfisher = KingfisherManager.shared
    static let baseURL = "https://adhder-assets.s3.amazonaws.com/mobileApp/images/"
    
    static func buildImageUrl(name: String, extension fileExtension: String = "") -> URL? {
        let actualName = substituteSprite(name: name)
        return URL(string: "\(baseURL)\(actualName).\(getFormat(name: actualName, format: fileExtension))")
    }
    
    private static let formatDictionary = [
        "head_special_0": "gif",
        "head_special_1": "gif",
        "shield_special_0": "gif",
        "weapon_special_0": "gif",
        "slim_armor_special_0": "gif",
        "slim_armor_special_1": "gif",
        "broad_armor_special_0": "gif",
        "broad_armor_special_1": "gif",
        "weapon_special_critical": "gif",
        "Pet-Wolf-Cerberus": "gif",
        "armor_special_ks2019": "gif",
        "slim_armor_special_ks2019": "gif",
        "broad_armor_special_ks2019": "gif",
        "eyewear_special_ks2019": "gif",
        "head_special_ks2019": "gif",
        "shield_special_ks2019": "gif",
        "weapon_special_ks2019": "gif",
        "Pet-Gryphon-Gryphatrice": "gif",
        "Mount_Head_Gryphon-Gryphatrice": "gif",
        "Mount_Body_Gryphon-Gryphatrice": "gif",
        "background_clocktower": "gif",
        "background_airship": "gif",
        "background_steamworks": "gif",
        "Pet_HatchingPotion_Veggie": "gif",
        "Pet_HatchingPotion_Dessert": "gif",
        "Pet-HatchingPotion-Dessert": "gif",
        "quest_windup": "gif",
        "Pet-HatchingPotion_Windup": "gif",
        "Pet_HatchingPotion_Windup": "gif",
        "Pet-HatchingPotion-Windup": "gif",
        "quest_solarSystem": "gif",
        "quest_lostMasterclasser4": "gif",
        "quest_virtualpet": "gif",
        "Pet_HatchingPotion_VirtualPet": "gif",
        "Pet-Gryphatrice-Jubilant": "gif",
        "stable_Pet-Gryphatrice-Jubilant": "gif",
        "back_special_heroicAureole": "gif",
        "Pet_HatchingPotion_Fungi": "gif",
        "shop_armoire": "gif",
        "Pet_HatchingPotion_Cryptid": "gif",
        "Mount_Head_Dragon-Hydra": "gif",
        "Mount_Body_Dragon-Hydra": "gif"
    ]
    
    @MainActor
    static func setImage(on imageView: NetworkImageView, name: String, extension fileExtension: String = "", completion: ((UIImage?, NSError?) -> Void)? = nil) {
        if imageView.loadedImageName != name {
            imageView.image = nil
        }
        imageView.loadedImageName = name
        getImage(name: name, extension: fileExtension) { (image, error) in
            if let error = error {
                logger.record(error: error)
            }
            if imageView.loadedImageName == name {
                imageView.layer.minificationFilter = .nearest
                imageView.layer.magnificationFilter = .nearest
                imageView.image = image
                if let action = completion {
                    action(image, error)
                }
            }
        }
    }
    
    static func getImage(name: String, extension fileExtension: String = "", completion: @escaping (UIImage?, NSError?) -> Void) {
        guard let url = ImageManager.buildImageUrl(name: name, extension: fileExtension) else {
            return
        }
        kingfisher.retrieveImage(with: url) { result in
            switch result {
            case .success(let imageResult):
                completion(imageResult.image, nil)
            case .failure(let error):
                logger.log("Error \(error.errorCode) loading \(url))", level: .error)
                completion(nil, error as NSError)
            }
        }
    }
    
    static func clearImageCache() {
        ImageCache.default.clearDiskCache()
        ImageCache.default.clearMemoryCache()
    }
    
    private static func getFormat(name: String, format: String) -> String {
        if !format.isEmpty {
            return format
        }
        return formatDictionary[name] ?? "png"
    }
    
    private static func substituteSprite(name: String) -> String {
        if let value = substitutions[name] {
            return (value as? String) ?? name
        }
        return name
    }
    
    static var substitutions = ConfigRepository.shared.dictionary(variable: .spriteSubstitutions)
}
