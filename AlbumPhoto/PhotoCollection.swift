import Photos

class PhotoCollection {
    
    private let collection: PHAssetCollection
    
    private(set) var localizedTitle: String?
    
    private(set) var photos: [PhotoWrapper] = []
    
    init(_ collection: PHAssetCollection) {
        self.collection = collection
        self.localizedTitle = collection.localizedTitle
        self.photos = PhotosHandler.photosAssets(collection).map { PhotoWrapper($0) }
    }
}

