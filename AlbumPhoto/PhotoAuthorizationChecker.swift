import Photos

class PhotoAuthorizationChecker {
    
    private var authorization: ((Bool) -> Void)?
    
    func cheakerAuthorization(authorization: ((Bool) -> Void)?) {
        self.authorization = authorization
        checkPhotoAuthorizatoin()
    }
    
    private func checkPhotoAuthorizatoin() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            requestPhotoAuthorization()
        case .authorized:
            authorization?(true)
        case .denied:
            authorization?(false)
        case .restricted:
            authorization?(false)
        }
    }
    
    private func requestPhotoAuthorization() {
        PHPhotoLibrary.requestAuthorization { [weak self] (status) in
            switch status {
            case .authorized:
                self?.authorization?(true)
            default:
                self?.authorization?(false)
            }
        }
    }
}
