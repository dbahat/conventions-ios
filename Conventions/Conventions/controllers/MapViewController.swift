//
//  MapViewController.swift
//  Conventions
//
//  Created by David Bahat on 3/7/16.
//  Copyright © 2016 Amai. All rights reserved.
//

class MapViewController: BaseViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    private var pageViewController: UIPageViewController!
    private var viewControllers = Array<UIViewController>();
    private var currentFloorIndex = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Vertical, options: nil);
        pageViewController.delegate = self;
        
        let floor1ViewController = storyboard!.instantiateViewControllerWithIdentifier(String(MapFloorViewController)) as! MapFloorViewController;
        let floor2ViewController = storyboard!.instantiateViewControllerWithIdentifier(String(MapFloorViewController)) as! MapFloorViewController;
        
        floor1ViewController.floorImage = UIImage(named: "Floor1");
        floor2ViewController.floorImage = UIImage(named: "Floor2");
        
        floor1ViewController.floor = 0
        floor2ViewController.floor = 1
        
        viewControllers = [floor1ViewController, floor2ViewController]
        pageViewController.setViewControllers([viewControllers[currentFloorIndex]],
            direction: .Forward,
            animated: false,
            completion: {done in });
        
        pageViewController.dataSource = self
        
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)

        pageViewController.didMoveToParentViewController(self);
        self.pageViewController = pageViewController;
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        updatePageTitle();
    }
    
    @IBAction func changeFloorWasClicked(sender: UIBarButtonItem) {
        // hack - since we
        currentFloorIndex = tabBarController?.title == "מפה - מפלס תחתון"
            ? 0 : 1
        let direction = currentFloorIndex == 1
            ? UIPageViewControllerNavigationDirection.Forward
            : UIPageViewControllerNavigationDirection.Reverse;
        currentFloorIndex = 1 - currentFloorIndex;
        
        pageViewController.setViewControllers([viewControllers[currentFloorIndex]],
            direction: direction,
            animated: true,
            completion: {done in });
        
        updatePageTitle();
    }
    
    private func updatePageTitle() {
        let floorName = currentFloorIndex == 0 ? "מפלס תחתון" : "מפלס עליון";
        tabBarController?.title = "מפה - " + floorName;
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let vc = viewController as? MapFloorViewController {
            if vc.floor == 1 {
                return nil
            }

            return viewControllers[1]
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let vc = viewController as? MapFloorViewController {
            if vc.floor == 0 {
                return nil
            }

            return viewControllers[0]
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed {
            return
        }
        
        if let currentController = previousViewControllers.first as? MapFloorViewController {
            currentFloorIndex = currentController.floor
        }
    }
}
