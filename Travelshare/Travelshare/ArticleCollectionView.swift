//
//  ArticleCollectionView.swift
//  Travelshare
//
//  Created by 康景炫 on 2021/2/24.
//

import UIKit
import Kingfisher

class ArticleCollectionView: BaseView {
    var data: [Article]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func commonInit() {
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private lazy var layout: UICollectionViewFlowLayout = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = hLineSpacing
        layout.minimumInteritemSpacing = hLineSpacing
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        var view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.register(ArticleCollectionViewCell.self, forCellWithReuseIdentifier: ArticleCollectionViewCell.reuseIdentifier)
        view.delegate = self
        view.dataSource = self
        view.clipsToBounds = true
        view.alwaysBounceVertical = true
        view.backgroundColor = .clear
        return view
    }()
    
    
}

extension ArticleCollectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.bounds.size.width, height: formatX(125))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArticleCollectionViewCell.reuseIdentifier, for: indexPath) as! ArticleCollectionViewCell
        
        if let article = data?[indexPath.row] {
            cell.fillData(article)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: hLineSpacing, bottom: 0, right: hLineSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let article = data?[indexPath.row] {
            let vc = ArticleDetailViewController(data: article)
            vc.hidesBottomBarWhenPushed = true
            self.currentViewController?.navigationController?.pushViewController(vc, animated: true)
        }   
    }
    
}



private class ArticleCollectionViewCell: BaseCollectionViewCell {
    override func commonInit() {
        addSubview(imageView)
        addSubview(titlelabel)
        addSubview(articleIntro)
        clipsToBounds = true
        layer.cornerRadius = 5
        
        titlelabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-hLineSpacing)
            make.leading.equalTo(imageView.snp.trailing).offset(8)
            make.top.equalToSuperview()
        }
        imageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(hLineSpacing)
            make.width.equalTo(formatX(110))
            make.bottom.top.equalToSuperview()
        }
        articleIntro.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(titlelabel)
            make.bottom.equalToSuperview()
            make.top.equalTo(titlelabel.snp.bottom).offset(12)
        }
    }
    
    private lazy var titlelabel: UILabel = {
        var titlelabel = UILabel()
        titlelabel.textAlignment = .left
        titlelabel.textColor = .init(hex: 0x222222)
        titlelabel.numberOfLines = 0
        titlelabel.font = UIFont.mediumFont(formatX(17))
        return titlelabel
    }()
    
    private lazy var articleIntro: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.textColor = .init(hex: 0x666666)
        label.font = UIFont.normalFont(formatX(13))
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = .red
        view.clipsToBounds = true
        view.layer.cornerRadius = formatX(6)
        return view
    }()
    
    override func fillData(_ data: Any?) {
        let article = data as! Article
        titlelabel.text = article.name
        articleIntro.text = article.article_introduction
        imageView.kf.setImage(with: URL(string: article.images[0]))
    }
}

