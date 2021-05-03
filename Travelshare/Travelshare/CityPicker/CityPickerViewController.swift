
//
//  CityPickerViewController.swift
//  Travelshare
//
//  Created by 康景炫 on 2021/2/28.
//

import UIKit

class CityPickerViewController: UIViewController {
    
    private let dataSource: [Country] = AppLogic.shared.allCountries
    
    private lazy var currentCountry: Country = dataSource.first!
    
    var handler: ((Country.City) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.view.addSubview(cityPickerView)
        cityPickerView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    private lazy var cityPickerView: UIPickerView = {
        let view = UIPickerView()
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .white
        return view
    }()
    
    class func show(from vc: UIViewController, hanlder:@escaping ((Country.City) -> Void)) {
        let tvc = CityPickerViewController()
        tvc.handler = hanlder
        tvc.modalTransitionStyle = .crossDissolve
        vc.present(tvc, animated: true, completion: nil)
    }
}

extension CityPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return dataSource.count
        }
        return currentCountry.cities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            let country = dataSource[row]
            return country.country
        }
        let city = currentCountry.cities[row]
        return city.c_name
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return UIScreen.width / 2.0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            currentCountry = dataSource[row]
            self.cityPickerView.reloadComponent(1)
        } else if component == 1 {
            let city = currentCountry.cities[row]
            handler?(city)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
