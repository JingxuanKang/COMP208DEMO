//
//  CityDetailViewController.swift
//  Travel share
//
//  Created by 康景炫 on 2021/2/15.
//

import UIKit

class ArticleDetailViewController: BaseViewController {
    
    let data: Article
    
    init(data: Article) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = data.name
        addBackButton {
            self.navigationController?.popViewController(animated: true)
        }
        imagesView.data = data
        authorNameLabel.text = data.author_name
        dateLabel.text = data.date
        descLabel.text = data.article_introduction
        addRightItem(UserAvatarView())
        loadData()
    }
    
    override func configViews() {
        view.addSubview(scrollView)
        view.addSubview(bottomView)
        
        bottomView.addSubview(likeButton)
        bottomView.addSubview(favouriteButton)
        bottomView.addSubview(commentButton)
        
        scrollView.addSubview(contentView)
        contentView.addSubview(authorNameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(imagesView)
        contentView.addSubview(descLabel)
        contentView.addSubview(commentTitleLabel)
        contentView.addSubview(commentView)
        
        bottomView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(80)
        }
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(navBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        authorNameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(hLineSpacing)
            make.leading.equalToSuperview().offset(hLineSpacing)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(authorNameLabel)
            make.trailing.equalToSuperview().offset(-hLineSpacing)
        }
        imagesView.snp.makeConstraints { (make) in
            make.top.equalTo(authorNameLabel.snp.bottom).offset(hLineSpacing)
            make.leading.equalToSuperview().offset(hLineSpacing)
            make.trailing.equalToSuperview().offset(-hLineSpacing)
        }
        descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imagesView.snp.bottom).offset(hLineSpacing)
            make.leading.equalToSuperview().offset(hLineSpacing)
            make.trailing.equalToSuperview().offset(-hLineSpacing)
        }
        commentTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(descLabel.snp.bottom).offset(hLineSpacing)
            make.leading.equalToSuperview().offset(hLineSpacing)
            make.trailing.equalToSuperview().offset(-hLineSpacing)
        }
        commentView.snp.makeConstraints { (make) in
            make.top.equalTo(commentTitleLabel.snp.bottom).offset(hLineSpacing)
            make.leading.equalToSuperview().offset(hLineSpacing)
            make.trailing.equalToSuperview().offset(-hLineSpacing)
            make.height.equalTo(0)
            make.bottom.equalToSuperview()
        }
        favouriteButton.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(likeButton)
            make.leading.equalToSuperview().offset(hLineSpacing)
        }
        commentButton.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(likeButton)
            make.centerX.equalToSuperview()
        }
        likeButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-hLineSpacing)
        }
    }
  
    private func loadData() {
        if let user = AppLogic.shared.user {
            AppLogic.shared.api.loadArticleDetail(articleId: data.a_id, userId: user.user_id) { (result) in
                if let article = try? result.get() {
                    DispatchQueue.main.async {
                        self.likeButton.isSelected = article.is_liked ?? false
                        self.favouriteButton.isSelected = article.is_favored ?? false
                        self.view.makeToast("Load data finished")
                    }
                }
            }
            AppLogic.shared.api.fetchCommentList(articleId: data.a_id) { (result) in
                if let list = try? result.get() {
                    DispatchQueue.main.async {
                        self.view.makeToast("Load Comments finished")
                        self.commentView.data = list
                        self.commentView.snp.updateConstraints { (make) in
                            make.height.equalTo(self.commentView.getHeight)
                            self.view.layoutIfNeeded()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Actions
    @objc private func likeAction() {
        guard let user = AppLogic.shared.user else {
            self.view.makeToast("Please login first")
            return
        }
        
        self.view.makeToastActivity(.center)
        self.likeButton.isUserInteractionEnabled = false
        
        AppLogic.shared.api.likeArticle(user: user, articleId: data.a_id, isUnlike: likeButton.isSelected) { (result) in
            DispatchQueue.main.async {
                self.view.hideToastActivity()
                self.likeButton.isUserInteractionEnabled = true

                switch result {
                case .success(_):
                    self.likeButton.isSelected = !self.likeButton.isSelected
                    self.view.makeToast("Action successfully")
                    
                case .failure(let error):
                    self.view.makeToast(error.localizedDescription)
                }
            }
        }
        AppLogic.shared.api.sendLike(user: user, articleId: data.a_id, eventType:"LIKE") { (result) in
            DispatchQueue.main.async {
                self.view.hideToastActivity()
//                self.view.makeToast("")
            }
        }
        AppLogic.shared.api.sendView(user: user, articleId: data.a_id, eventType:"VIEW") { (result) in
            DispatchQueue.main.async {
                self.view.hideToastActivity()
//                self.view.makeToast("")
            }
        }
    }
    
    @objc private func favouriteAction() {
        guard let user = AppLogic.shared.user else {
            self.view.makeToast("Please login first")
            return
        }
        
        self.view.makeToastActivity(.center)
        self.favouriteButton.isUserInteractionEnabled = false
        AppLogic.shared.api.favouriteArticle(user: user, articleId:data.a_id, isCancel: favouriteButton.isSelected) { (result) in
            DispatchQueue.main.async {
                self.view.hideToastActivity()
                self.favouriteButton.isUserInteractionEnabled = true
                
                switch result {
                case .success(_):
                    self.favouriteButton.isSelected = !self.favouriteButton.isSelected
                    self.view.makeToast("Action successfully")
                    
                case .failure(let error):
                    self.view.makeToast(error.localizedDescription)
                }
            }
        }
        AppLogic.shared.api.sendFavorite(user: user, articleId: data.a_id, eventType:"COLLECTION") { (result) in
            DispatchQueue.main.async {
                self.view.hideToastActivity()
//                self.view.makeToast("")
            }
        }
        AppLogic.shared.api.sendView(user: user, articleId: data.a_id, eventType:"VIEW") { (result) in
            DispatchQueue.main.async {
                self.view.hideToastActivity()
//                self.view.makeToast("")
            }
        }
    }
    
    @objc private func commentAction() {
        let vc = CommentViewController()
        vc.articleId = self.data.a_id
        vc.successHandler = { [weak self] in
            self?.loadData()
        }
        self.currentViewController?.present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Getters
    private let imagesView: ArticleImageCollectionView = .init()
    private let commentView: commentCollectionView = .init()
    
    private lazy var scrollView: UIScrollView = {
        var view = UIScrollView()
        view.isDirectionalLockEnabled = true
        view.alwaysBounceHorizontal = false
        view.alwaysBounceVertical = true
        return view
    }()
    
    private lazy var authorNameLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.font = .mediumFont(formatX(14))
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.font = .mediumFont(formatX(14))
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var commentTitleLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.font = .mediumFont(formatX(17))
        label.textColor = .black
        label.text = "Comments"
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.font = .normalFont(formatX(15))
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let contentView: UIView = .init()
    private let bottomView: UIView = .init()
    
    private lazy var favouriteButton: ArticleActionButton = {
        var view = ArticleActionButton()
        view.setImage(UIImage(named: "favorite")?.colored(appNormalMainColor), selectedImage: UIImage(named: "favorite")?.colored(appMainColor))
        view.setTitle("Favourite")
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(favouriteAction)))
        return view
    }()
    private lazy var likeButton: ArticleActionButton = {
        var view = ArticleActionButton()
        view.setImage(UIImage(named: "good")?.colored(appNormalMainColor), selectedImage: UIImage(named: "good")?.colored(appMainColor))
        view.setTitle("Like")
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(likeAction)))
        return view
    }()
    private lazy var commentButton: ArticleActionButton = {
        var view = ArticleActionButton()
        view.setImage(UIImage(named: "comment-filling")?.colored(appNormalMainColor), selectedImage: UIImage(named: "comment-filling")?.colored(appMainColor))
        view.setTitle("Comment")
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(commentAction)))
        return view
    }()
    
}
