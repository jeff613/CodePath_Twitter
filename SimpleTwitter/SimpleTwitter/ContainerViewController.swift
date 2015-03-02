//
//  ContainerViewController.swift
//  SimpleTwitter
//
//  Created by Jianfeng Ye on 2/28/15.
//  Copyright (c) 2015 Dion613. All rights reserved.
//

import UIKit

protocol MenuToggler {
    func toggleMenu()
}

protocol MenuDelegate {
    func selectMenuItem(index: Int)
}

class ContainerViewController: UIViewController, MenuToggler, MenuDelegate {

    var menuViewController: MenuViewController?
    var contentViewController: UIViewController!
    var contentNaviController: UINavigationController!
    
    var curIndex: Int = 0
    let contentViewIds: [String] = ["HomeNavigation", "ProfileNavigation", "MentionsNavigation"]
    
    var menuOpen: Bool = false
    
    func loadContentView(id: String) -> UIViewController {
        let navi = storyboard?.instantiateViewControllerWithIdentifier(id) as UINavigationController
        view.addSubview(navi.view)
        addChildViewController(navi)
        navi.didMoveToParentViewController(self)
        contentNaviController = navi
        
        contentViewController = navi.viewControllers.first as UIViewController
        return contentViewController
    }
    
    func removeCurrentView() {
        if contentNaviController != nil {
            contentNaviController.view.removeFromSuperview()
            contentNaviController.removeFromParentViewController()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadContentView("HomeNavigation")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectMenuItem(index: Int) {
        if curIndex != index {
            removeCurrentView()
            loadContentView(contentViewIds[index])
            animateMenu(false)
            curIndex = index
        }
    }
    
    func addMenu() {
        if (menuViewController == nil) {
            menuViewController = storyboard?.instantiateViewControllerWithIdentifier("SideMenu") as? MenuViewController
            if let menu = menuViewController {
                view.insertSubview(menu.view, atIndex: 0)
                addChildViewController(menu)
                menu.didMoveToParentViewController(self)
                
                menu.delegate = self
            }
        }
    }
    
    func toggleMenu() {
        if !menuOpen {
            addMenu()
            animateMenu(true)
        } else {
            animateMenu(false)
        }
    }
    
    func animateMenu(expand: Bool) {
        if expand {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.contentNaviController.view.frame.origin.x = 200
                }) { finished in
                    self.menuOpen = true
            }
        } else {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.contentNaviController.view.frame.origin.x = 0
                }) { finished in
                    self.menuOpen = false
            }
        }
    }
    
    @IBAction func onPan(sender: UIPanGestureRecognizer) {
        let leftToRight = sender.velocityInView(view).x > 0
        switch(sender.state) {
        case .Began:
            if leftToRight {
                addMenu()
            }
        case .Changed:
            if !leftToRight && contentNaviController.view.frame.origin.x <= 0 {
                contentNaviController.view.frame.origin.x = 0
                break
            }
            contentNaviController.view.center.x += sender.translationInView(view).x
            sender.setTranslation(CGPointZero, inView: view)
        case .Ended:
            animateMenu(contentNaviController.view.frame.origin.x > 100)
        default:
            break
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
