//
//  ArticleImageCollectionViewController.swift
//  Travel share
//
//  Created by 康景炫 on 2021/2/19.
//


import UIKit
import Kingfisher

class ArticleImageCollectionView: BaseView {
    
    var data: Article? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func commonInit() {
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(collectionView.snp.width).multipliedBy(9.0/16.0)
            make.bottom.equalToSuperview()
        }
    }
    
    private lazy var layout: UICollectionViewFlowLayout = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        var view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.register(DetailImageCell.self, forCellWithReuseIdentifier: DetailImageCell.reuseIdentifier)
        view.delegate = self
        view.dataSource = self
        view.clipsToBounds = true
        view.isPagingEnabled = true
        view.contentInsetAdjustmentBehavior = .never
        view.backgroundColor = .clear
        return view
    }()
}

extension ArticleImageCollectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailImageCell.reuseIdentifier, for: indexPath) as! DetailImageCell
        if let imageNameUrl = data?.images[indexPath.row] {
            cell.fillData(imageNameUrl)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}


private class DetailImageCell: BaseCollectionViewCell {
    override func commonInit() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private lazy var imageView: UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()
    
    override func fillData(_ data: Any?) {
        guard let imagename = data as? String else {
            return
        }
        let string  = (imagename as NSString).addingPercentEscapes(using: String.Encoding.utf8.rawValue)!
        if let url = URL(string: string) {
            imageView.kf.setImage(with: url)
        } else {
            imageView.backgroundColor = .gray
        }
    }
}


