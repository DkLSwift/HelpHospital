//
//  NeedsPageViewController.swift
//  HelpHospital
//
//  Created by Eric DkL on 06/04/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit

class NeedsPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    


    lazy var vcs : [UIViewController] = {
        return [MyNeedsViewController(), AllNeedsViewController()]
    }()
    
    let myNeedButton: UIButton = {
           let btn = UIButton()
           btn.backgroundColor = blue
           btn.setTitle("Mes Besoins", for: .normal)
           btn.setTitleColor(.white, for: .normal)
           return btn
       }()
       let allNeedsButton: UIButton = {
              let btn = UIButton()
              btn.backgroundColor = blue
              btn.setTitle("Tous les Besoins", for: .normal)
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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
        
        let hStack = UIStackView(arrangedSubviews: [myNeedButton, allNeedsButton])
        hStack.distribution = .fillEqually
        view.addSubview(hStack)
        hStack.anchor(top: safeTopAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 50))
        
        let separator = UIView()
        separator.backgroundColor = .white
        separator.constrainHeight(constant: 1)
        
        view.addSubview(separator)
        separator.anchor(top: hStack.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        
        myNeedButton.addTarget(self, action: #selector(handleMyNeeds), for: .touchUpInside)
        allNeedsButton.addTarget(self, action: #selector(handleAllNeeds), for: .touchUpInside)
    }
    
    @objc func handleAllNeeds() {
        self.goToNextPage()
    }
    @objc func handleMyNeeds() {
        self.goToPreviousPage()
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


