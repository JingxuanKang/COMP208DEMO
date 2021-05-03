//
//  mainViewController.swift
//  Travel share
//
//  Created by 康景炫 on 2021/2/10.
//

import UIKit

class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        tabBar.isTranslucent = false
        creatSubViewControllers()
    }
    
    func creatSubViewControllers() {
        let size = CGSize.init(width: 32, height: 32)
        
        let v1  = UINavigationController(rootViewController: RecommendPageViewController())
        let item1 : UITabBarItem = UITabBarItem (title: "Today", image: UIImage(named: "today")?.resize(to: size), selectedImage: UIImage(named: "home_1")?.resize(to: size))
        v1.tabBarItem = item1
        
        let v2 = UINavigationController(rootViewController: ImagesShareCollectionViewController())
        let item2 : UITabBarItem = UITabBarItem (title: "Discover", image: UIImage(named: "world")?.resize(to: size), selectedImage: UIImage(named: "favor_1")?.resize(to: size))
        v2.tabBarItem = item2
        
        let v3 = UINavigationController(rootViewController: CityListViewController())
        let item3 : UITabBarItem = UITabBarItem (title: "City", image: UIImage(named: "citylist")?.resize(to: size), selectedImage: UIImage(named: "me_1")?.resize(to: size))
        v3.tabBarItem = item3
        
        let v4  = UINavigationController(rootViewController: UserViewController())
        let item4 : UITabBarItem = UITabBarItem (title: "Me", image: UIImage(named: "person")?.resize(to: size), selectedImage: UIImage(named: "person")?.resize(to: size))
        v4.tabBarItem = item4
        
        let tabArray = [v1, v2, v3,v4]
        self.viewControllers = tabArray
    }
}






