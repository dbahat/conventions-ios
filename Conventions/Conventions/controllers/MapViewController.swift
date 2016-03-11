//
//  MapViewController.swift
//  Conventions
//
//  Created by David Bahat on 3/7/16.
//  Copyright © 2016 Amai. All rights reserved.
//

class MapViewController: BaseViewController, UIPageViewControllerDelegate {

    var pageViewController: UIPageViewController!
    var viewControllers = Array<UIViewController>();
    var currentFloorIndex = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Vertical, options: nil);
        pageViewController.delegate = self;
        
        let floor1ViewController = storyboard!.instantiateViewControllerWithIdentifier(String(MapFloorViewController)) as! MapFloorViewController;
        let floor2ViewController = storyboard!.instantiateViewControllerWithIdentifier(String(MapFloorViewController)) as! MapFloorViewController;
        
        floor1ViewController.floorImage = UIImage(named: "Floor1");
        floor2ViewController.floorImage = UIImage(named: "Floor2");
        
        viewControllers = [floor1ViewController, floor2ViewController]
        pageViewController.setViewControllers([viewControllers[currentFloorIndex]],
            direction: .Forward,
            animated: false,
            completion: {done in });
        
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
    
    func updatePageTitle() {
        let floorName = currentFloorIndex == 0 ? "מפלס תחתון" : "מפלס עליון";
        tabBarController?.title = "מפה - " + floorName;
    }
}
