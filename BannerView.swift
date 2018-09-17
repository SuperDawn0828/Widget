
import UIKit

class BannerViewLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        minimumLineSpacing = 0
        scrollDirection = .horizontal
        if let collectionView = collectionView {
            itemSize = collectionView.bounds.size
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        guard let collectionView = collectionView else { return attributes }
        let newAttributes = attributes.compactMap({ (attribute) -> UICollectionViewLayoutAttributes? in
            guard let copy = attribute.copy() as? UICollectionViewLayoutAttributes else { return nil }
            copy.frame = CGRect(x: copy.frame.origin.x, y: 0, width: collectionView.frame.width, height: collectionView.frame.height)
            return copy
        })

        return newAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return  true
    }
}


class BannerViewCell: UICollectionViewCell {
    
    private(set) var imageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadSubviews()
    }
    
    private func loadSubviews() {
        imageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
}

protocol BannerViewDelegate: class {
    func bannerView(bannerView: BannerView, clickAtIndex index: Int)
}

class BannerView: UIView {
    
    private var collectionView: UICollectionView!
    private var pageControl: UIPageControl!
    private var placeholderImageView: UIImageView!
    
    private var _sourceImages: [ImageSource] = []
    
    weak var delegate: BannerViewDelegate?
    
    var images: [ImageSource]? {
        didSet {
            bannerViewSourceImages()
        }
    }
    
    var pageIndicatorColor: UIColor? {
        didSet {
            pageControl.pageIndicatorTintColor = pageIndicatorColor
        }
    }
    
    var currentPageIndicatorColor: UIColor? {
        didSet {
            pageControl.currentPageIndicatorTintColor = currentPageIndicatorColor
        }
    }
    
    var pageAlignment: PageControlAlignment = .center {
        didSet {
            setPageControlAlignment()
        }
    }
    
    var pageBottomSpacing: CGFloat = 0 {
        didSet {
            setPageControlAlignment()
        }
    }
    
    var bannerPlaceholderImage: UIImage? {
        didSet {
            placeholderImageView.image = bannerPlaceholderImage
        }
    }
    
    var placeholderImage: UIImage?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadSubviews()
    }
    
    private func loadSubviews() {
        let flowLayout = BannerViewLayout()
        flowLayout.itemSize = CGSize(width: frame.width, height: frame.height)
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = false
        collectionView.register(BannerViewCell.self, forCellWithReuseIdentifier: "BannerViewCell")
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        addSubview(collectionView)
        
        pageControl = UIPageControl(frame: .zero)
        pageControl.numberOfPages = 0
        addSubview(pageControl)
        setPageControlAlignment()
        
        placeholderImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        placeholderImageView.isHidden = true
        placeholderImageView.contentMode = .scaleAspectFill
        placeholderImageView.clipsToBounds = true
        addSubview(placeholderImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let layout = collectionView.collectionViewLayout as? BannerViewLayout, layout.itemSize != frame.size {
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            let flowLayout = BannerViewLayout()
            flowLayout.itemSize = frame.size
            collectionView.setCollectionViewLayout(flowLayout, animated: false)
        } else {
            collectionView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        }
        placeholderImageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        setPageControlAlignment()
    }
}

extension BannerView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _sourceImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerViewCell", for: indexPath) as! BannerViewCell
        
        let source = _sourceImages[indexPath.row]
        switch source {
        case .imageNamed(let named):
            cell.imageView.image = UIImage(named: named)
        case .url(let url):
            cell.imageView.yy_setImage(with: URL(string: url),
                                  placeholder: placeholderImage,
                                  options: [.showNetworkActivity])
        }
        
        return cell
    }
}

extension BannerView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var index: Int = 0
        if _sourceImages.count == 1 {
            index = 0
        } else if indexPath.row == 0 {
            index = _sourceImages.count - 3
        } else if indexPath.row == _sourceImages.count - 1 {
            index = 0
        } else {
            index = indexPath.row - 1
        }
        
        delegate?.bannerView(bannerView: self, clickAtIndex: index)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard _sourceImages.count > 1 else { return }
        
        let index = Int(scrollView.contentOffset.x / frame.width)
        if index >= _sourceImages.count - 2 {
            if scrollView.contentOffset.x - (CGFloat(_sourceImages.count - 2) * frame.width) > frame.width / 2.0 {
                pageControl.currentPage = 0
                scrollView.contentOffset.x = scrollView.contentOffset.x - (CGFloat(_sourceImages.count - 2) * frame.width)
            } else {
                pageControl.currentPage = index - 1
            }
        } else if index <= 0 {
            if scrollView.contentOffset.x < frame.width / 2.0 {
                scrollView.contentOffset.x = frame.width * CGFloat(_sourceImages.count - 2) + scrollView.contentOffset.x
                pageControl.currentPage = _sourceImages.count - 3
            }
        } else {
            pageControl.currentPage = index - 1
        }
    }
}

extension BannerView {
    
    enum PageControlAlignment {
        case left
        case right
        case center
    }
    
    private func setPageControlAlignment() {
        let size = pageControl.size(forNumberOfPages: pageControl.numberOfPages)
        
        let pageControlY = frame.height - size.height - pageBottomSpacing
        switch pageAlignment {
        case .left:
            pageControl.frame = CGRect(x: 20, y: pageControlY, width: size.width, height: size.height)
        case .center:
            pageControl.frame = CGRect(x: (frame.width - size.width) * 0.5, y: pageControlY, width: size.width, height: size.height)
        case .right:
            pageControl.frame = CGRect(x: frame.width - size.width - 20, y: pageControlY, width: size.width, height: size.height)
        }
    }
}

extension BannerView {
    
    enum ImageSource {
        case url(String)
        case imageNamed(String)
        
        static func imageURLSources(_ images: [String]) -> [ImageSource] {
            return images.map { ImageSource.url($0) }
        }
        
        static func imageNamedSources(_ images: [String]) -> [ImageSource] {
            return images.map { ImageSource.imageNamed($0) }
        }
    }
    
    private func bannerViewSourceImages() {
        _sourceImages.removeAll()
        
        guard let images = images else {
            placeholderImageView.isHidden = false
            collectionView.reloadData()
            return
        }

        if images.count == 0 {
            placeholderImageView.isHidden = false
            collectionView.reloadData()
        } else if images.count > 1 {
            placeholderImageView.isHidden = true
            
            pageControl.isHidden = false
            pageControl.currentPage = 0
            pageControl.numberOfPages = images.count
            setPageControlAlignment()
            
            let firstImage = images.first!
            let lastImage = images.last!
            _sourceImages.append(lastImage)
            _sourceImages.append(contentsOf: images)
            _sourceImages.append(firstImage)
            
            collectionView.reloadData()
            collectionView.scrollToItem(at: IndexPath.init(item: 1, section: 0), at: UICollectionViewScrollPosition(rawValue: 0), animated: false)
        } else {
            placeholderImageView.isHidden = true
            
            pageControl.isHidden = true
            _sourceImages.append(contentsOf: images)
            collectionView.reloadData()
            collectionView.scrollToItem(at: IndexPath.init(item: 0, section: 0), at: UICollectionViewScrollPosition(rawValue: 0), animated: false)
        }
    }
}
