//
//  UserInterfaceAttribute.swift
//  Travelshare
//
//  Created by 康景炫 on 2021/2/21.
//


import UIKit

class UserInterfaceAttribute: BaseView {
    
    func getViewHeight() -> CGFloat {
        return CGFloat(dataSource.count) * UserInterfaceAttribute.cellHeight
    }

    var user: User? = AppLogic.shared.user {
        didSet {
            collectionView.reloadData()
        }
    }
    
    enum UserAttributeType: String {
        case email = "Email"
        case photoNumber = "PhoneNumber"
        case liked = "Liked"
        case records = "Records"
        case birthday = "Brithday"
        case favourites = "Favourites"
    }
    
    var dataSource: [UserAttributeType] = [.email, .photoNumber, .birthday, .favourites, .liked, .records,]
    
    private class var cellHeight: CGFloat {
        return formatX(44)
    }
    
    var data: User? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func commonInit() {
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(hLineSpacing)
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
        view.register(UserInterfaceAttributeCell.self, forCellWithReuseIdentifier: UserInterfaceAttributeCell.reuseIdentifier)
        view.delegate = self
        view.dataSource = self
        view.clipsToBounds = true
        view.isPagingEnabled = true
        view.contentInsetAdjustmentBehavior = .never
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        return view
    }()
}


extension UserInterfaceAttribute: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.bounds.size.width, height: Self.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserInterfaceAttributeCell.reuseIdentifier, for: indexPath) as! UserInterfaceAttributeCell
        let type = dataSource[indexPath.row]
        switch type {
        case .birthday:
            cell.fillData(type.rawValue + ":" + (user?.birthday ?? ""))
            cell.leftimageView.image = UIImage(named: "cake")?.colored(.black)
            cell.imageView.isHidden = false
        case .email:
            cell.fillData(type.rawValue + ":" + (user?.email ?? ""))
            cell.leftimageView.image = UIImage(named: "email")?.colored(.black)
            cell.imageView.isHidden = false
        case .photoNumber:
            cell.fillData(type.rawValue + ":" + (user?.phone_number ?? ""))
            cell.leftimageView.image = UIImage(named: "telephone")?.colored(.black)
            cell.imageView.isHidden = false
        case .liked:
            cell.fillData(type.rawValue)
            cell.leftimageView.image = UIImage(named: "good")?.colored(.black)
            cell.imageView.isHidden = true
        case .records:
            cell.fillData(type.rawValue)
            cell.leftimageView.image = UIImage(named: "history")?.colored(.black)
            cell.imageView.isHidden = true
        case .favourites:
            cell.fillData(type.rawValue)
            cell.leftimageView.image = UIImage(named: "favorite")?.colored(.black)
            cell.imageView.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = dataSource[indexPath.row]
        switch type {
        case .favourites:
            guard AppLogic.shared.user != nil else {
                self.makeToast("Please login at first")
                return
            }
            
            let vc = UserArticleViewController(type: .favourite)
            vc.hidesBottomBarWhenPushed = true
            self.currentViewController?.navigationController?.pushViewController(vc, animated: true)
            
        case .liked:
            guard AppLogic.shared.user != nil else {
                self.makeToast("Please login at first")
                return
            }

            let vc = UserArticleViewController(type: .liked)
            vc.hidesBottomBarWhenPushed = true
            self.currentViewController?.navigationController?.pushViewController(vc, animated: true)
            
        case .records:
            guard AppLogic.shared.user != nil else {
                self.makeToast("Please login at first")
                return
            }

            let vc = UserArticleViewController(type: .record)
            vc.hidesBottomBarWhenPushed = true
            self.currentViewController?.navigationController?.pushViewController(vc, animated: true)
            
        case .email:
            let vc = EditUserInfoViewController(type: .email)
            self.currentViewController?.present(vc, animated: true, completion: nil)
            
        case .photoNumber:
            let vc = EditUserInfoViewController(type: .phoneNumber)
            self.currentViewController?.present(vc, animated: true, completion: nil)

        case .birthday:
            let vc = EditUserInfoViewController(type: .birthday)
            self.currentViewController?.present(vc, animated: true, completion: nil)
        }
    }
}

private class UserInterfaceAttributeCell: BaseCollectionViewCell {
    override func commonInit() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-hLineSpacing)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        contentView.addSubview(leftimageView)
        leftimageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(hLineSpacing)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(leftimageView.snp.trailing).offset(hLineSpacing)
            make.trailing.equalToSuperview().offset(-hLineSpacing)
            make.top.equalToSuperview().offset(hLineSpacing)
        }
    }
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
//        label.font = .normalFont(formatX(12))
        label.textColor = .init(hex: 0x222222)
        label.font = UIFont.mediumFont(formatX(17))
        label.numberOfLines = 0
        return label
    }()
    lazy var imageView: UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage.init(named: "edit")
        return view
    }()
    lazy var leftimageView: UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage.init(named: "edit")
        return view
    }()

    override func fillData(_ data: Any?) {
        guard let name = data as? String else {
            return
        }
        titleLabel.text = name
    }
}
