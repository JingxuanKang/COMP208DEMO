//
//  UploadImagesViewCell.swift
//  Travelshare
//
//  Created by 康景炫 on 2021/3/31.
//

import UIKit

class UploadImagesViewCell: BaseCollectionViewCell {
    
    var deleteActionHandler: (() -> Void)?
        
    override func commonInit() {
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        addSubview(deleteView)
        deleteView.snp.makeConstraints { (make) in
            make.trailing.top.equalToSuperview()
            make.height.width.equalTo(24)
        }
    }
    
    override func fillData(_ data: Any?) {
        guard let image = data as? UIImage else {
            imageView.image = nil
            return
        }
        imageView.image = image
    }
    
    @objc private func deelteAction() {
        deleteActionHandler?()
    }
    
    private lazy var imageView: UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }()
    private lazy var deleteView: UIButton = {
        var view = UIButton()
        view.setImage(UIImage.init(named: "minus"), for: .normal)
        view.imageView?.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.addTarget(self, action: #selector(deelteAction), for: .touchUpInside)
        return view
    }()
}

class UploadImagesViewAddCell: BaseCollectionViewCell {
    override func commonInit() {
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    private lazy var imageView: UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .white
        view.image = UIImage.init(named: "add-circle")
        view.clipsToBounds = true
        return view
    }()
}
