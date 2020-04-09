//
//  ContributionPageViewController.swift
//  HelpHospital
//
//  Created by Eric DkL on 07/04/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit

class ContributionPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    


    lazy var vcs : [UIViewController] = {
        return [MyContributionViewController(), AllContributionsViewController()]
    }()
    
    let myContribButton: UIButton = {
           let btn = UIButton()
           btn.backgroundColor = blueMinus
           btn.setTitle("Mes Contributions", for: .normal)
           btn.setTitleColor(bluePlus, for: .normal)
           return btn
       }()
       let allContribButton: UIButton = {
              let btn = UIButton()
              btn.backgroundColor = blue
              btn.setTitle("Toutes les Contributions", for: .normal)
              btn.setTitleColor(.white, for: .normal)
              return btn
          }()
       
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
        
        if let firstVC = vcs.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
        setupUI()
        
    }
    
    func setupUI() {
        var safeTopAnchor = view.topAnchor
        var safeBottomAnchor = view.bottomAnchor
        
        if #available(iOS 11.0, *) {
            safeTopAnchor = view.safeAreaLayoutGuide.topAnchor
            safeBottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
        }
        
        let hStack = UIStackView(arrangedSubviews: [myContribButton, allContribButton])
        hStack.distribution = .fillEqually
        view.addSubview(hStack)
        hStack.anchor(top: safeTopAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 50))
        
        let separator = UIView()
        separator.backgroundColor = .white
        separator.constrainHeight(constant: 1)
        
        view.addSubview(separator)
        separator.anchor(top: hStack.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        
        myContribButton.addTarget(self, action: #selector(handleMyContrib), for: .touchUpInside)
        allContribButton.addTarget(self, action: #selector(handleAllContrib), for: .touchUpInside)
    }
    
    @objc func handleAllContrib() {
        allContributionsPressed()
        self.goToNextPage()
    }
    @objc func handleMyContrib() {
        myContributionsPressed()
        self.goToPreviousPage()
       }
    func allContributionsPressed() {
        myContribButton.setTitleColor(.white, for: .normal)
        myContribButton.backgroundColor = blue
        
        allContribButton.setTitleColor(bluePlus, for: .normal)
        allContribButton.backgroundColor = blueMinus
       
    }
    func myContributionsPressed() {
         allContribButton.setTitleColor(.white, for: .normal)
         allContribButton.backgroundColor = blue
         
         myContribButton.setTitleColor(bluePlus, for: .normal)
         myContribButton.backgroundColor = blueMinus
        
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = vcs.firstIndex(of: viewController) else { return nil }
        let previousIndex = vcIndex - 1
        guard previousIndex >= 0 else { return nil }
        guard vcs.count > previousIndex else { return nil }
        
        return vcs[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = vcs.firstIndex(of: viewController) else { return nil }
        let nextIndex = vcIndex + 1
        guard vcs.count != nextIndex else { return nil }
        guard vcs.count > nextIndex else { return nil}
        
        return vcs[nextIndex]
    }
    
    

}


