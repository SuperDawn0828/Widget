import Photos

class PhotoWrapper {
    
    private(set) var asset: PHAsset
    
    private var image: UIImage?
    
    init(_ asset: PHAsset) {
        self.asset = asset
    }
    
    func updateImage(callBack: @escaping (UIImage?) -> Void) {
        if let image = image {
            callBack(image)
        } else {
            PhotosHandler.fetchImage(by: asset) { [weak self] (image) in
                self?.image = image
                callBack(image)
            }
        }
    }
}
