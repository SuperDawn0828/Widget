import Photos

class PhotoManager {
    
    private(set) var collections: [PhotoCollection] = []

    init() {
        self.collections = PhotosHandler.photosAssetCollections().map { PhotoCollection($0) }
    }
}
