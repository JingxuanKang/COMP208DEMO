//
//  FourthTableTableViewController.swift
//  Travel share
//
//  Created by 康景炫 on 2021/2/10.
//

import UIKit

class CityListViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var dataSource: [Country] = AppLogic.shared.allCountries
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "City Tour"
        addRightItem(UserAvatarView())
        loadData()
    }
    
    override func configViews() {
        view.addSubview(citySearchBar)
        view.addSubview(collectionView)
        citySearchBar.snp.makeConstraints { (make) in
            make.top.equalTo(navBar.snp.bottom)
            make.height.equalTo(30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(formatX(-32))
        }
        collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(citySearchBar.snp.bottom)
        }
    }
    
    private func loadData() {
        self.view.makeToastActivity(.center)
        AppLogic.shared.loadCityList { (result) in
            self.view.hideToastActivity()
            
            switch result {
            case .failure(let error):
                self.view.makeToast(error.localizedDescription)
                
            case .success(let list):
                self.dataSource = list
                self.collectionView.reloadData()
            }
        }
    }
    
    private func getDataSourceBy(searchText: String) -> [Country] {
        if searchText.count == 0 {
            return AppLogic.shared.allCountries
        }
        
        var filterCountries: [Country] = .init()
        for country in AppLogic.shared.allCountries {
            var filterCities: [Country.City] = .init()
            for city in country.cities {
                if city.c_name.uppercased().contains(searchText.uppercased()) {
                    filterCities.append(city)
                }
            }
            if filterCities.count > 0 {
                filterCountries.append(Country(country: country.country, cities: filterCities))
            }
        }
        return filterCountries
    }
    
    private lazy var layout: UICollectionViewFlowLayout = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = hLineSpacing
        layout.minimumInteritemSpacing = hLineSpacing
        return layout
    }()
    
    private lazy var citySearchBar: UISearchBar = {
        let view = UISearchBar()
        view.tintColor = .init(hex: 0x120f1d)
        view.autocapitalizationType = .none
        view.autocorrectionType = .no
        view.spellCheckingType = .no
        view.returnKeyType = .continue
        view.enablesReturnKeyAutomatically = true
        view.delegate = self
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        var view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.register(CityItemCollectionViewCell.self, forCellWithReuseIdentifier: CityItemCollectionViewCell.reuseIdentifier)
        view.register(CityCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CityCollectionReusableView.reuseIdentifier)
        view.delegate = self
        view.dataSource = self
        view.clipsToBounds = true
        view.alwaysBounceVertical = true
        view.isPagingEnabled = false
        view.backgroundColor = .clear
        //        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
}

extension CityListViewController {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].cities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: UIScreen.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: UIScreen.width, height: formatX(60))
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CityCollectionReusableView.reuseIdentifier, for: indexPath) as! CityCollectionReusableView
            view.fillData(country: dataSource[indexPath.section])
            return view
        } else {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: BaseCollectionReusableView.reuseIdentifier, for: indexPath)
            return view
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let country = dataSource[indexPath.section]
        let city = country.cities[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CityItemCollectionViewCell.reuseIdentifier, for: indexPath) as! CityItemCollectionViewCell
        cell.fillData(city)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: hLineSpacing, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let country = dataSource[indexPath.section]
        let city = country.cities[indexPath.row]
        let vc = CityDetailViewController(city: city)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CityListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("xxxxxxxxxx is: \(searchText)")
        self.dataSource = getDataSourceBy(searchText: searchText)
        self.collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        self.dataSource = getDataSourceBy(searchText: "")
        self.collectionView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = nil
        self.dataSource = getDataSourceBy(searchText: "")
        self.collectionView.reloadData()
    }
}
