//
//  BaseViewController.swift
//  Travel share
//
//  Created by 康景炫 on 2021/2/10.
//

import UIKit
import Closures

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isHidden = true
//        navBar.backgroundColor = .red
        
        view.addSubview(navBar)
        navBar.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
            make.top.equalToSuperview().offset(UIDevice.statusBarHeight)
        }

        configViews()
    }
    
    func configViews() {
    }
    
    override var title: String? {
        didSet {
            if titleLabel.superview == nil {
                navBar.addSubview(titleLabel)
                titleLabel.snp.makeConstraints { (make) in
                    make.centerX.equalToSuperview()
                    make.centerY.equalToSuperview()
                    make.width.equalToSuperview().multipliedBy(0.6)
                    make.height.equalTo(44)
                }
            }
            titleLabel.text = title
        }
    }
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.font = .mediumFont(18)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    let navBar: UIView = .init()
}

extension BaseViewController {
    func addBackButton(image: UIImage? = UIImage.init(named: "back"), action: (()->Void)? = nil) {
        let button = UIButton(type: .custom)
        
        button.contentMode = .center
        button.setImage(image, for: .normal)
        view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.width.height.equalTo(44)
            make.top.equalToSuperview().offset(UIDevice.statusBarHeight)
            make.leading.equalToSuperview().offset(16)
        }
        button.on(.touchUpInside) { (_, _) in
            action?()
        }
    }
    
    func addRightItem(_ view: UIView) {
        self.navBar.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-hLineSpacing)
        }
    }
    
    func setupTitle(_ title: String) {
        if let titleLabel = view.viewWithTag(102) as? UILabel {
            titleLabel.text = title
        } else {
            let label = UILabel()
            label.text = title.uppercased()
            label.tag = 102
            label.textAlignment = .center
//            label.font = AppResource.boldFont(formatX(18))
            label.textColor = .white
            label.numberOfLines = 1
            view.addSubview(label)
            label.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(UIDevice.statusBarHeight)
                make.centerX.equalToSuperview()
                make.height.equalTo(44)
            }
        }
    }
    
}

extension BaseViewController {
    func addKeybordKvo() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIApplication.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
    }
}
