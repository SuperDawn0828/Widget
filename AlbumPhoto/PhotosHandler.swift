import Photos

class PhotosHandler {

    static func photosAssetCollections() -> [PHAssetCollection] {
        var collections: [PHAssetCollection] = []
        let allResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        allResult.enumerateObjects { (collection, index, objcBool) in
            collections.append(collection)
        }
        let userResult = PHAssetCollection.fetchTopLevelUserCollections(with: nil)
        userResult.enumerateObjects { (collection, index, objcBool) in
            if collection is PHAssetCollection {
                collections.append(collection as! PHAssetCollection)
            }
        }
        return collections
    }
    
    static func photosAssets(_ collection: PHAssetCollection) -> [PHAsset] {
        var assets: [PHAsset] = []
        let assetResult = PHAsset.fetchAssets(in: collection, options: nil)
        assetResult.enumerateObjects { (asset, index, objcBool) in
            assets.append(asset)
        }
        return assets
    }
    
    static func fetchImage(by asset: PHAsset, complection: @escaping (UIImage?) -> Void) {
        
        let targetSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
        
        let option = PHImageRequestOptions()
        option.resizeMode = .fast
        option.isSynchronous = false
        option.deliveryMode = .highQualityFormat
        
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: option) { (image, info) in
            complection(image)
        }
    }
}
