//
//  CityDetailViewController.swift
//  Travel share
//
//  Created by 康景炫 on 2021/2/15.
//

import UIKit
import MapKit
class CityDetailViewController: BaseViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var city: Country.City


    init(city: Country.City) {
        self.city = city
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = city.c_name
        addBackButton {
            self.navigationController?.popViewController(animated: true)
        }
        addRightItem(UserAvatarView())
        loadArticles()
        
        locationManager.delegate = self as CLLocationManagerDelegate //we want messages about location
         locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
         locationManager.requestWhenInUseAuthorization() //ask the user for permission to get their location
         locationManager.startUpdatingLocation() //and start receiving those messages (if we’re allowed to)
    }
    
    override func configViews() {
        view.addSubview(scrollView)
        infoView.data = city

        scrollView.addSubview(contentView)
        contentView.addSubview(mapView)
        contentView.addSubview(infoView)
        contentView.addSubview(notesView)
        
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(navBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        mapView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(mapView.snp.width).multipliedBy(9.0/16.0)
        }
        infoView.snp.makeConstraints { (make) in
            make.top.equalTo(mapView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        notesView.snp.makeConstraints { (make) in
            make.top.equalTo(infoView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(notesView.getViewHeight())
            make.bottom.equalToSuperview()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userSource = AppLogic.shared.user else {
            self.view.makeToast("Please login first")
            return
        }
    let locationOfUser = locations[0] //get the first location (ignore any others)
    let latitude = locationOfUser.coordinate.latitude
    let longitude = locationOfUser.coordinate.longitude
        _ = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        userSource.latitude=String(latitude)
        userSource.longitude=String(longitude)
    }
    
    private func loadArticles() {
        self.view.makeToastActivity(.center)
        AppLogic.shared.fetchArticles(by: city.c_id) { result in
            DispatchQueue.main.async {
                self.view.hideToastActivity()
                switch result {
                case .success(let articles):
                    self.notesView.data = articles
                    self.notesView.snp.updateConstraints { (make) in
                        make.height.equalTo(self.notesView.getViewHeight())
                    }
                    
                case .failure(let error):
                    self.view.makeToast(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Getters
    private lazy var mapView: MKMapView = {
        var view = MKMapView()
        let location = CLLocationCoordinate2D(latitude: Double(city.latitude) ?? 0,
                                              longitude: Double(city.longitude) ?? 0)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        view.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = city.c_name
        view.addAnnotation(annotation)
        return view
    }()
    private let infoView: CityDetailInfoView = .init()
    private let notesView: CityDetailNotesView = .init()
    
    private lazy var scrollView: UIScrollView = {
        var view = UIScrollView()
        view.isDirectionalLockEnabled = true
        view.alwaysBounceHorizontal = false
        view.alwaysBounceVertical = true
        return view
    }()
    
    private let contentView: UIView = .init()
}
