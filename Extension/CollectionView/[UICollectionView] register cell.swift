public extension UICollectionView {
    public func register(cellType: UICollectionViewCell.Type, bundle: Bundle? = nil) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: className)
    }

    public func register(cellTypes: [UICollectionViewCell.Type], bundle: Bundle? = nil) {
        cellTypes.forEach { register(cellType: $0, bundle: bundle) }
    }

    public func register(reusableViewType: UICollectionReusableView.Type,
                         ofKind kind: String = UICollectionElementKindSectionHeader,
                         bundle: Bundle? = nil) {
        let className = reusableViewType.className
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: className)
    }

    public func register(reusableViewTypes: [UICollectionReusableView.Type],
                         ofKind kind: String = UICollectionElementKindSectionHeader,
                         bundle: Bundle? = nil) {
        reusableViewTypes.forEach { register(reusableViewType: $0, ofKind: kind, bundle: bundle) }
    }

    public func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type,
                                                             for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: type.className, for: indexPath) as! T
    }

    public func dequeueReusableView<T: UICollectionReusableView>(with type: T.Type,
                                                                 for indexPath: IndexPath,
                                                                 ofKind kind: String = UICollectionElementKindSectionHeader) -> T {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: type.className, for: indexPath) as! T
    }
}


collectionView.register(cellType: MyCell.self)
collectionView.register(cellTypes: [MyCell1.self, MyCell2.self])
let cell = collectionView.dequeueReusableCell(with: MyCell.self, for: indexPath)

collectionView.register(reusableViewType: MyReusableView.self)
collectionView.register(reusableViewTypes: [MyReusableView1.self, MyReusableView2.self])
let view = collectionView.dequeueReusableView(with: MyReusableView.self, for: indexPath)
