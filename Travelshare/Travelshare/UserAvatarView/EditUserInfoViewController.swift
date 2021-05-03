//
//  EditUserInfoViewController.swift
//  Travelshare
//
//  Created by 康景炫 on 2021/4/30.
//

import UIKit

class EditUserInfoViewController: BaseViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    var articleId: Int!
    var successHandler: (()-> Void)?
    
    private let type: UserInfoType
    
    init(type: UserInfoType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.title = "Change \(type.rawValue)"
        [view].forEach { (view) in
            let tap = UITapGestureRecognizer(handler: { [weak self] (_) in
                self?.textView.resignFirstResponder()
            })
            tap.delegate = self
            view!.addGestureRecognizer(tap)
        }
        addKeybordKvo()
    }
    
    override func configViews() {
        view.addSubview(textView)
        view.addSubview(publishButton)
        publishButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-hLineSpacing)
            make.centerY.equalTo(navBar)
            make.width.height.equalTo(formatX(30))
        }
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(navBar.snp.bottom).offset(hLineSpacing)
            make.height.equalTo(30)
            make.left.equalToSuperview().offset(hLineSpacing)
            make.trailing.equalToSuperview().offset(-hLineSpacing)
        }
    }
    
    override func keyboardWillShow(_ notification: Notification) {
//        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardRectangle = keyboardFrame.cgRectValue
//            let keyboardHeight = keyboardRectangle.height
//        }
    }
    
    override func keyboardWillHide(_ notification: Notification) {
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
        guard let content = self.textView.text else {
            self.view.makeToast("Please input the content")
            return
        }
        guard let user = AppLogic.shared.user else {
            self.view.makeToast("Please login at first")
            return
        }
        self.view.makeToastActivity(.center)

        let email = type == .email ? content : user.email
        let phoneNumber = type == .phoneNumber ? content : user.phone_number
        let birthday = type == .birthday ? content : user.birthday
        AppLogic.shared.api.updateUserInfo(user: user, email: email, phoneNumber: phoneNumber, birthday: birthday) { result in
            DispatchQueue.main.async {
                self.view.hideToastActivity()
                switch result {
                case .failure(let error):
                    self.view.makeToast(error.localizedDescription)
                    
                case .success(_):
                    let user = AppLogic.shared.user
                    user?.email = email
                    user?.phone_number = phoneNumber
                    user?.birthday = birthday
                    AppLogic.shared.user = user
                    
                    UIApplication.shared.keyWindow?.rootViewController?.view.makeToast("Upate User Information Successfully")
                    self.successHandler?()
                    self.dismiss(animated: true, completion: nil)
                    NotificationCenter.default.post(.init(name: .init("userinfoChanged")))
                }
            }
        }
    }
    
    private lazy var textView: UITextView = {
        var view = UITextView()
        view.textAlignment = .left
        view.font = .normalFont(formatX(12))
        view.textColor = .black
        view.allowsEditingTextAttributes = true
        view.placeholder = type == .birthday ? AppLogic.shared.user?.birthday : (type == .email ? AppLogic.shared.user?.email : AppLogic.shared.user?.phone_number) ?? ""
        view.placeholderColor = appNormalMainColor
        view.alwaysBounceVertical = true
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.init(hex: 0x999999).cgColor
        view.layer.borderWidth = 1
        return view
    }()

}

extension EditUserInfoViewController {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if  self.textView.isFirstResponder {
            return true
        } else {
            return false
        }
    }
}
