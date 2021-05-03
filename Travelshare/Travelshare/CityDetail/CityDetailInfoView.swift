//
//  CityDetailInfoView.swift
//  Travel share
//
//  Created by 康景炫 on 2021/2/19.
//

import UIKit

class CityDetailInfoView: BaseView {
    
    var data: Country.City? {
        didSet {
            collectionView.reloadData()//现在reload是什么时候的 哦根据城市reload
            descLabel.text = data?.city_introduction
            pageControl.numberOfPages = data?.images.count ?? 0
        }
    }

    override func commonInit() {
        addSubview(titleLabel)
        addSubview(collectionView)
        addSubview(descLabel)
        addSubview(pageControl)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(hLineSpacing)
            make.trailing.equalToSuperview().offset(-hLineSpacing)
            make.top.equalToSuperview().offset(hLineSpacing)
        }
        collectionView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(hLineSpacing)
            make.trailing.equalToSuperview().offset(-hLineSpacing)
            make.top.equalTo(titleLabel.snp.bottom).offset(hLineSpacing)
            make.height.equalTo(collectionView.snp.width).multipliedBy(9.0/16.0)
        }
        descLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(collectionView.snp.bottom).offset(hLineSpacing)
            make.bottom.equalToSuperview().offset(-hLineSpacing)
        }
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(collectionView.snp.bottom).offset(-8)
            make.height.equalTo(5)
            make.width.equalToSuperview()
        }
    }
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.font = .mediumFont(formatX(16))
        label.textColor = .black
        label.text = "City Introduction"
        label.numberOfLines = 0
        return label
    }()
    private lazy var descLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.font = .mediumFont(formatX(14))
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
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
    
    private lazy var pageControl: UIPageControl = {
        var view = UIPageControl()
        view.currentPageIndicatorTintColor = .red
        view.pageIndicatorTintColor = .blue
        view.currentPage = 0
        view.isUserInteractionEnabled = true
        return view
    }()
}

extension CityDetailInfoView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index: Int = Int(scrollView.contentOffset.x / collectionView.frame.size.width)
        pageControl.currentPage = index
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
        imageView.kf.setImage(with: URL(string: imagename)!)
    }
}


