//
//  commentViewController.swift
//  Travelshare
//
//  Created by 康景炫 on 2021/4/1.
//

import UIKit

class CommentViewController: BaseViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    var articleId: Int!
    var successHandler: (()-> Void)?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        title = "Comment"
        [view, scrollView].forEach { (view) in
            let tap = UITapGestureRecognizer(handler: { [weak self] (_) in
                self?.articleContentTextView.resignFirstResponder()
            })
            tap.delegate = self
            view!.addGestureRecognizer(tap)
        }
        addKeybordKvo()
    }
    
    override func configViews() {
        view.addSubview(scrollView)
        view.addSubview(publishButton)
        
        scrollView.addSubview(contentView)
        contentView.addSubview(articleContentTextView)
        
        publishButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-hLineSpacing)
            make.centerY.equalTo(navBar)
            make.width.height.equalTo(formatX(30))
        }
        
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(navBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        articleContentTextView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(hLineSpacing)
            make.height.equalTo(UIScreen.height - 100)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(formatX(-32))
            make.bottom.equalToSuperview().offset(-hLineSpacing)
        }
    }
    
    override func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            scrollView.snp.updateConstraints { (make) in
                make.bottom.equalToSuperview().offset(-formatX(keyboardHeight) - 10)
            }
        }
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        scrollView.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview().offset(-formatX(120))
        }
    }
    
    // MARK: -
    private lazy var publishButton: UIButton = {
        var button = UIButton(type: .custom)
        button.setImage(UIImage(named: "navigation")?.colored(appMainColor), for: .normal)
        button.addTarget(self, action: #selector(publishAction), for: .touchUpInside)
        button.imageView?.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        return button
    }()
    
    @objc private func publishAction() {
        guard let content = self.articleContentTextView.text else {
            self.view.makeToast("Please input comment")
            return
        }
        guard let user = AppLogic.shared.user else {
            self.view.makeToast("Please login at first")
            return
        }
        self.view.makeToastActivity(.center)
        AppLogic.shared.api.publishComment(user: user, articleId: articleId, content: content) { (result) in
            DispatchQueue.main.async {
                self.view.hideToastActivity()
                switch result {
                case .failure(let error):
                    self.view.makeToast(error.localizedDescription)
                    
                case .success(_):
                    UIApplication.shared.keyWindow?.rootViewController?.view.makeToast("Comment Successfully")
                    self.successHandler?()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    private lazy var articleContentTextView: UITextView = {
        var view = UITextView()
        view.textAlignment = .left
        view.font = .normalFont(formatX(12))
        view.textColor = .black
        view.allowsEditingTextAttributes = true
        view.placeholder = "Please Input the content."
        view.placeholderColor = appNormalMainColor
        view.alwaysBounceVertical = true
        view.backgroundColor = .white
        view.layer.cornerRadius = formatX(6)
        return view
    }()
    private lazy var scrollView: UIScrollView = {
        var view = UIScrollView()
        view.isDirectionalLockEnabled = true
        view.alwaysBounceHorizontal = false
        view.alwaysBounceVertical = true
        return view
    }()
    private let contentView: UIView = .init()
    
    private let uploadImageView: UploadImagesView = .init()
}


extension CommentViewController {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if  self.articleContentTextView.isFirstResponder {
            return true
        } else {
            return false
        }
    }
}
