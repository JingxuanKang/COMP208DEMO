//
//  PublishViewController.swift
//  Travelshare
//
//  Created by 康景炫 on 2021/2/27.
//

import UIKit
import UITextView_Placeholder

class PublishViewController: BaseViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    override func viewDidLoad(){
        super.viewDidLoad()
        
        title = "Create notes"
        [view, scrollView].forEach { (view) in
            let tap = UITapGestureRecognizer(handler: { [weak self] (_) in
                self?.titleTextFiled.resignFirstResponder()
                self?.cityChooseButton.resignFirstResponder()
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
        contentView.addSubview(titleTextFiled)
        contentView.addSubview(cityChooseButton)
        contentView.addSubview(uploadImageView)
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
        titleTextFiled.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(hLineSpacing)
            make.height.equalTo(formatX(24))
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(formatX(-32))
        }
        cityChooseButton.snp.makeConstraints { (make) in
            make.top.equalTo(titleTextFiled.snp.bottom).offset(hLineSpacing)
            make.height.equalTo(formatX(24))
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(formatX(-32))
        }
        uploadImageView.snp.makeConstraints { (make) in
            make.top.equalTo(cityChooseButton.snp.bottom).offset(hLineSpacing)
            make.height.equalTo(UploadImagesView.CellSize)
            make.leading.trailing.equalToSuperview()
        }
        articleContentTextView.snp.makeConstraints { (make) in
            make.top.equalTo(uploadImageView.snp.bottom).offset(hLineSpacing)
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
        guard let cityId = self.selectedCity?.c_id else {
            self.view.makeToast("Please select a city first")
            return
        }
        guard let title = titleTextFiled.text else {
            self.view.makeToast("Please Fill the title first")
            return
        }
        guard let content = articleContentTextView.text else {
            self.view.makeToast("Please Fill the content first")
            return
        }
        guard let user = AppLogic.shared.user else {
            self.view.makeToast("Please login first")
            return
        }
        let images = self.uploadImageView.dataSource
        if images.count == 0 {
            self.view.makeToast("Please select one image at first")
            return
        }

        var params: Api.NewBlogParms = .init()
        params.cityId = String(cityId)
        params.title = title
        params.content = content
        params.userId = String(user.user_id)
        params.password = user.password
        params.images = images
        params.username = user.username
        
        self.view.makeToastActivity(.center)
        AppLogic.shared.api.createNewBlog(params: params) { [weak self] (result) in
            DispatchQueue.main.async {
                self?.view.hideToastActivity()
                
                switch result {
                case .success(_):
                    UIApplication.shared.keyWindow?.makeToast("Publish Successfully")
                    self?.dismiss(animated: true, completion: nil)
                    
                case .failure(let error):
                    self?.view.makeToast(error.localizedDescription)
                }
            }
        }
    }
    
    @objc private func chooseCityAction() {
        CityPickerViewController.show(from: self) { (city) in
            self.selectedCity = city
            self.cityChooseButton.setTitle(city.c_name, for: .normal)
        }
    }
    
    //////////////////////////////////////
    private lazy var titleTextFiled: UITextField = {
        let view = UITextField()
        view.backgroundColor = .white
        view.attributedPlaceholder = NSAttributedString(string: "Type Title", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0x120f1d).withAlphaComponent(0.7),
        ])
        view.tintColor = .init(hex: 0x120f1d)
        view.textColor = .init(hex: 0x120f1d)
        view.autocapitalizationType = .none
        view.autocorrectionType = .no
        view.spellCheckingType = .no
        view.returnKeyType = .continue
        view.enablesReturnKeyAutomatically = true
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1.0
        view.delegate = self
        return view
    }()
    
    private lazy var cityChooseButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .white
        view.setTitle("Choose City", for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.addTarget(self, action: #selector(chooseCityAction), for: .touchUpInside)
        view.titleLabel?.textAlignment = .left
        view.titleLabel?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        return view
    }()
    
    private lazy var articleContentTextView: UITextView = {
        var view = UITextView()
        view.textAlignment = .left
        view.font = .normalFont(formatX(12))
        view.textColor = .black
        view.placeholder = "Please Input the content."
        view.placeholderColor = appNormalMainColor
        view.allowsEditingTextAttributes = true
        view.alwaysBounceVertical = true
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
    
    private var selectedCity: Country.City?
}


extension PublishViewController {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if self.titleTextFiled.isFirstResponder || self.cityChooseButton.isFirstResponder || self.articleContentTextView.isFirstResponder {
            return true
        } else {
            return false
        }
    }
}
