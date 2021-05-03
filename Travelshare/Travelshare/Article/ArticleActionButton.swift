//
//  favoriteView.swift
//  Travel share
//
//  Created by 康景炫 on 2021/2/19.
//

import UIKit

class ArticleActionButton: BaseView {
    
    var isSelected: Bool = false {
        didSet {
            imageView.isHighlighted = isSelected
        }
    }
    
    func setTitle(_ string: String) {
        mainLabel.text = string
    }
    
    func setImage(_ image: UIImage?, selectedImage: UIImage?) {
        imageView.image = image
        imageView.highlightedImage = selectedImage
    }

    override func commonInit() {
        addSubview(imageView)
        addSubview(mainLabel)
        imageView.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
            make.width.height.equalTo(formatX(30))
        }
        mainLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private lazy var mainLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.font = .normalFont(formatX(10))
        label.textColor = appNormalMainColor
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
}
