//
//  OnBoardingPageController.swift
//  HelpHospital
//
//  Created by Eric DkL on 15/04/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//


import UIKit

class OnBoardingPageController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    lazy var vcs : [UIViewController] = {
        return [FirstSlideVC(), SecondSlideVC()]
    }()
    
    var pageControll = UIPageControl()
    
    let gotItButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = blue
        btn.setTitle("J'ai compris", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    var isDismissable = false

    
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
            
//        if let myView = view?.subviews.first as? UIScrollView {
//            myView.canCancelContentTouches = false
//        }
        
        _ = Timer.scheduledTimer(withTimeInterval: 4, repeats: true, block: { (_ ) in
        })
    }
    
    func setupUI() {
        var safeTopAnchor = view.topAnchor
        var safeBottomAnchor = view.bottomAnchor
        
        if #available(iOS 11.0, *) {
            safeTopAnchor = view.safeAreaLayoutGuide.topAnchor
            safeBottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
        }
        
       
        view.addSubview(gotItButton)
        gotItButton.anchor(top: nil, leading: view.leadingAnchor, bottom: safeBottomAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: 44))
        
        gotItButton.addTarget(self, action: #selector(handleGotIt), for: .touchUpInside)
        
        configurePageControll()
    }
    
    func configurePageControll() {
//           pageControll = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - UIScreen.main.bounds.height * 23 / 100, width: UIScreen.main.bounds.width, height: 50))
        pageControll = UIPageControl()
        view.addSubview(pageControll)
        pageControll.translatesAutoresizingMaskIntoConstraints = false
        pageControll.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControll.bottomAnchor.constraint(equalTo: gotItButton.topAnchor, constant: -20).isActive = true
           pageControll.numberOfPages = vcs.count
           pageControll.currentPage = 0
           pageControll.tintColor = UIColor.black
           pageControll.pageIndicatorTintColor = blueMinus
           pageControll.currentPageIndicatorTintColor = bluePlus
           self.view.addSubview(pageControll)
        
    }
    
    @objc func handleGotIt() {
        if isDismissable {
            self.dismiss(animated: true, completion: nil)
        } else {
            let controller = HomeTabController()
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        }
        
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
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControll.currentPage = vcs.firstIndex(of: pageContentViewController)!
    }

}


