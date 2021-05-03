//
//  CityDetailNotesView.swift
//  Travel share
//
//  Created by 康景炫 on 2021/2/19.
//

import UIKit

class CityDetailNotesView: BaseView {
    
    private class var cellHeight: CGFloat {
        return formatX(44)
    }
    
    var data: [Article]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func commonInit() {
        addSubview(collectionView)
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(hLineSpacing)
            make.trailing.equalToSuperview().offset(-hLineSpacing)
            make.top.equalToSuperview().offset(hLineSpacing)
        }
        collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(hLineSpacing)
        }
        
    }
    
    private lazy var layout: UICollectionViewFlowLayout = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        var view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.register(ArticleCell.self, forCellWithReuseIdentifier: ArticleCell.reuseIdentifier)
        view.delegate = self
        view.dataSource = self
        view.clipsToBounds = true
        view.isPagingEnabled = true
        view.contentInsetAdjustmentBehavior = .never
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        return view
    }()
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.font = .mediumFont(formatX(17))
        label.textColor = .black
        label.text = "Recommended Travel notes"
        label.numberOfLines = 0
        return label
    }()
}

extension CityDetailNotesView {
    func getViewHeight() -> CGFloat {
        return CGFloat(data?.count ?? 0) * CityDetailNotesView.cellHeight + 40
    }
}

extension CityDetailNotesView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.bounds.size.width, height: Self.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArticleCell.reuseIdentifier, for: indexPath) as! ArticleCell
        if let article = data?[indexPath.row] {
            cell.fillData(article)
            cell.imageView.image = UIImage(named: "read")?.colored(.blue)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let article = data?[indexPath.row] {
            let vc = ArticleDetailViewController(data: article)
            vc.hidesBottomBarWhenPushed = true
            self.currentViewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
                   
private class ArticleCell: BaseCollectionViewCell {
    override func commonInit() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(hLineSpacing)
            make.trailing.equalToSuperview().offset(-hLineSpacing)
            make.top.equalToSuperview().offset(hLineSpacing)
        }
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints{ (make) in
            make.trailing.equalToSuperview().offset(-hLineSpacing)
            make.top.equalToSuperview().offset(hLineSpacing)
            make.width.height.equalTo(24)
            
        }
    }
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.font = .normalFont(formatX(17))
        label.textColor = .blue
        label.numberOfLines = 0
        return label
    }()
    lazy var imageView: UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage.init(named: "read")
        return view
    }()
    
    override func fillData(_ data: Any?) {
        guard let article = data as? Article else {
            return
        }
        titleLabel.text = article.name
    }
}
