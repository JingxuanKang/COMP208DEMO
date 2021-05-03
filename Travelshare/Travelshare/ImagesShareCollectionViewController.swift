//
//  ImagesShareCollectionViewController.swift
//  Travel share
//
//  Created by 康景炫 on 2021/2/20.
//

import UIKit
import ESPullToRefresh


class ImagesShareCollectionViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var data: [ImageShare]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Discover"
        addRightItem(UserAvatarView())
        data = AppLogic.shared.allImageShares
        collectionView.es.startPullToRefresh()
        loadData()
    }
    
    override func configViews() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
        }
        enablePullToRefresh()
    }
    
    private func enablePullToRefresh() {
        guard collectionView.es.base.header == nil else {return}
        collectionView.es.addPullToRefresh {
            self.loadData()
        }
    }
    
    private var isRefreshing: Bool = false
    private func loadData() {
        if isRefreshing {
            return
        }
        isRefreshing = true
        
        if AppLogic.shared.allImageShares.count == 0 {
            self.view.makeToastActivity(.center)
        }
        AppLogic.shared.fetchImageShares { (result) in
            DispatchQueue.main.async {
                self.isRefreshing = false
                self.view.hideToastActivity()
                self.collectionView.es.stopPullToRefresh()
                
                switch result {
                case .failure(let error):
                    self.view.makeToast(error.localizedDescription)
                    
                case .success(let list):
                    self.data = list
                    self.collectionView.reloadData()
                }
            }
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
        view.register(ImagesShareCollectionViewCell.self, forCellWithReuseIdentifier: ImagesShareCollectionViewCell.reuseIdentifier)
        view.delegate = self
        view.dataSource = self
        view.clipsToBounds = true
        view.alwaysBounceVertical = true
        view.isPagingEnabled = true
        view.backgroundColor = .clear
        //        view.contentInsetAdjustmentBehavior = .never
        return view
    }()    
}

extension ImagesShareCollectionViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: UIScreen.width, height: UIScreen.width*9.0/16.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagesShareCollectionViewCell.reuseIdentifier, for: indexPath) as! ImagesShareCollectionViewCell
        if let name = data?[indexPath.row].image {
            cell.fillData(name)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: hLineSpacing, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let navvc = self.currentViewController is UINavigationController ? (self.currentViewController as! UINavigationController) : self.currentViewController?.navigationController
        
        guard let image = data?[indexPath.row] else {return}
        
        if let model = AppLogic.shared.fetchSource(of: image) as? Article {
            let vc = ArticleDetailViewController(data: model)
            vc.hidesBottomBarWhenPushed = true
            navvc?.pushViewController(vc, animated: true)
        } else if let model = AppLogic.shared.fetchSource(of: image) as? Country.City {
            let vc = CityDetailViewController(city: model)
            vc.hidesBottomBarWhenPushed = true
            navvc?.pushViewController(vc, animated: true)
        }
    }
}

private class ImagesShareCollectionViewCell: BaseCollectionViewCell {
    override func commonInit() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(hLineSpacing)
            make.right.equalToSuperview().offset(-hLineSpacing)
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
        guard let name = data as? String else {
            return
        }
        if let url = URL(string: name) {
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "background"))
        } else {
            imageView.image = UIImage(named: "background")
        }
    }
}


