//
//  UserArticleViewController.swift
//  Travelshare
//
//  Created by 康景炫 on 2021/2/22.
//

import UIKit

class UserArticleViewController: BaseViewController {
    
    var user: User = AppLogic.shared.user!
    
    var articleList: [ArticleListResponse]?
    
    enum FormType {
        case favourite
        case liked
        case record
    }
    
    let type: FormType
    
    init(type: FormType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        addBackButton {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func configViews() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
        }
    }
    
    private func fetchData() {
        self.view.makeToastActivity(.center)
        self.view.isUserInteractionEnabled = false
        AppLogic.shared.fetchUserArticles(by: user, type: type) { [weak self] (result) in
            DispatchQueue.main.async {
                self?.view.isUserInteractionEnabled = true
                self?.view.hideToastActivity()
                switch result {
                case .failure(let error):
                    self?.view.makeToast(error.localizedDescription)
                case .success(let articles):
                    self?.articleList = articles
                    self?.collectionView.reloadData()
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
        view.register(ArticleCell.self, forCellWithReuseIdentifier: ArticleCell.reuseIdentifier)
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

extension UserArticleViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articleList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: UIScreen.width, height: formatX(60))
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArticleCell.reuseIdentifier, for: indexPath) as! ArticleCell
        if let model = articleList?[indexPath.row] {
            cell.fillData(model)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = articleList?[indexPath.row] else {
            return
        }
        if let user = AppLogic.shared.user {
            self.view.makeToastActivity(.center)
            AppLogic.shared.api.loadArticleDetail(articleId: data.article_id, userId: user.user_id) { (result) in
                DispatchQueue.main.async {
                    self.view.hideToastActivity()
                    if let article = try? result.get() {
                        let vc = ArticleDetailViewController(data: article)
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    } else {
                        self.view.makeToast("Load data failed")
                    }
                }
            }
        }
    }
}

private class ArticleCell: BaseCollectionViewCell {
    
    override func commonInit() {
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(hLineSpacing)
        }
    }
    
    override func fillData(_ data: Any?) {
        guard let imagename = data as? ArticleListResponse else {
            return
        }
        label.text = String(imagename.title)
    }
    
    private lazy var label: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
}
