//
//  commentCollectionView.swift
//  Travelshare
//
//  Created by 康景炫 on 2021/4/1.
//
import UIKit
import Kingfisher

class commentCollectionView: BaseView {
    
    var getHeight: CGFloat {
        return CGFloat(data?.count ?? 0) * (44.0 + hLineSpacing)
    }
    
    var data: [CommentListResponse]? {
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
    
    private lazy var collectionView: UICollectionView = {
        var view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.register(commentCollectionViewCell.self, forCellWithReuseIdentifier: commentCollectionViewCell.reuseIdentifier)
        view.delegate = self
        view.dataSource = self
        view.clipsToBounds = true
        view.alwaysBounceVertical = true
        //        view.isPagingEnabled = true
        view.isScrollEnabled = false
        view.backgroundColor = .clear
        //        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    
    
}


extension commentCollectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.bounds.size.width - 2 * hLineSpacing, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: commentCollectionViewCell.reuseIdentifier, for: indexPath) as! commentCollectionViewCell
        
        if let article = data?[indexPath.row] {
            cell.fillData(article)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: hLineSpacing)
    }
    
}



private class commentCollectionViewCell: BaseCollectionViewCell {
    override func commonInit() {
        addSubview(titlelabel)
//        addSubview(articleIntro)
        clipsToBounds = true
        layer.cornerRadius = 5
        backgroundColor = .clear
        
        titlelabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().offset(-hLineSpacing)
            make.top.equalToSuperview().offset(3)
        }
//        articleIntro.snp.makeConstraints { (make) in
//            make.leading.equalToSuperview()
//            make.trailing.equalToSuperview()
//            make.top.equalTo(titlelabel).offset(0)
//            make.bottom.equalToSuperview().offset(-hLineSpacing)
//        }
    }
    
    private lazy var titlelabel: UILabel = {
        var titlelabel = UILabel()
        titlelabel.textAlignment = .left
        titlelabel.textColor = .red
        titlelabel.font = .mediumFont(formatX(13))
        titlelabel.numberOfLines = 1
        return titlelabel
    }()
    
//    private lazy var articleIntro: UILabel = {
//        var label = UILabel()
//        label.textAlignment = .left
//        label.font = .mediumFont(formatX(13))
//        label.textColor = .black
//        label.numberOfLines = 0
//        return label
//    }()
    
    override func fillData(_ data: Any?) {
        let article = data as! CommentListResponse
        titlelabel.text = article.comment_content
//        articleIntro.text = article.article_introduction
    }
}

