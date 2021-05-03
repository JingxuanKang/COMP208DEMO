//
//  RecommendPage.swift
//  Travelshare
//
//  Created by 康景炫 on 2021/2/24.
//

import UIKit

class RecommendPageViewController: BaseViewController, UISearchBarDelegate{
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Today"
        addRightItem(UserAvatarView())
        artCollView.data = AppLogic.shared.allArticles
        artCollView.collectionView.es.startPullToRefresh()
        loadData()
    }
    
    override func configViews(){
        view.addSubview(searchBar)
        view.addSubview(titlelabel)
        view.addSubview(artCollView)
        
        searchBar.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(hLineSpacing)
            make.trailing.equalToSuperview().offset(-hLineSpacing)
            make.top.equalTo(navBar.snp.bottom).offset(hLineSpacing)
            make.height.equalTo(formatX(30))
        }
        titlelabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(hLineSpacing)
            make.top.equalTo(searchBar.snp.bottom).offset(hLineSpacing)
        }
        artCollView.snp.makeConstraints { (make) in
            make.top.equalTo(titlelabel.snp.bottom).offset(hLineSpacing)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        enablePullToRefresh()
    }
    
    private func enablePullToRefresh() {
        guard artCollView.collectionView.es.base.header == nil else {return}
        artCollView.collectionView.es.addPullToRefresh {
            self.loadData()
        }
    }
    
    // MARK: -
    private var isRefreshing: Bool = false
    private func loadData() {
        if isRefreshing {
            return
        }
        isRefreshing = true

        if AppLogic.shared.allArticles.count == 0 {
            self.view.makeToastActivity(.center)
        }
        
        AppLogic.shared.loadArticleList(userId:AppLogic.shared.user?.user_id ?? 9999) { (result) in
            self.isRefreshing = false
            self.artCollView.collectionView.es.stopPullToRefresh()
            self.view.hideToastActivity()
            
            switch result {
            case .failure(let error):
                self.view.makeToast(error.localizedDescription)
                
            case .success(let list):
                self.artCollView.data = list
            }
        }
    }
    
    // MARK: - Getters
    private lazy var titlelabel: UILabel = {
        var titlelabel = UILabel()
        titlelabel.text = "Today Recommend"
        titlelabel.textAlignment = .left
        titlelabel.textColor = .init(hex: 0x222222)
        titlelabel.numberOfLines = 0
        return titlelabel
    }()
    
    private lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.tintColor = .init(hex: 0x120f1d)
        view.autocapitalizationType = .none
        view.autocorrectionType = .no
        view.spellCheckingType = .no
        view.returnKeyType = .continue
        view.enablesReturnKeyAutomatically = true
        view.delegate = self
        return view
    }()
    
    private let artCollView: ArticleCollectionView = .init()
}
