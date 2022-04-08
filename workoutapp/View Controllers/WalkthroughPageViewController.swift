//
//  WalkthroughPageViewController.swift
//  workoutapp
//
//  Created by Negar on 2020-08-13.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit

protocol WalkthroughPageViewControllerDelegate: AnyObject {
    func didUpdatePageIndex(currentIndex: Int)
}

class WalkthroughPageViewController: UIPageViewController {
    
    // MARK: - Properties
    
    weak var walkthroughDelegate: WalkthroughPageViewControllerDelegate?
    let allOnboardingPages = OnboardingPage.allPages
    var currentIndex = 0
    var contentVCs: [WalkthroughContentViewController?] = []

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        for _ in 0..<allOnboardingPages.count {
            contentVCs.append(nil)
        }
        
        if let startingViewController = contentViewController(at: 0) {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    // MARK: - Helpers
    
    func contentViewController(at index: Int) -> WalkthroughContentViewController? {
        guard allOnboardingPages.indices.contains(index) else { return nil }
        
        if let contentVC = contentVCs[index] {
            return contentVC
        }
        
        let storyboard = UIStoryboard(name: "Walkthrough", bundle: nil)
        if let pageContentViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughContentViewController") as? WalkthroughContentViewController {
            let currentPage = allOnboardingPages[index]
            pageContentViewController.onboardingPage = currentPage
            pageContentViewController.index = index
            
            contentVCs[index] = pageContentViewController
            return pageContentViewController
        }
        
        return nil
    }
    
    func forwardPage() {
        currentIndex += 1
        if let nextViewController = contentViewController(at: currentIndex){
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
}

// MARK: - Page View Controller

extension WalkthroughPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index -= 1
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index += 1
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let contentViewController = pageViewController.viewControllers?.first as? WalkthroughContentViewController {
                currentIndex = contentViewController.index
                walkthroughDelegate?.didUpdatePageIndex(currentIndex: currentIndex)
            }
        }
    }
}
