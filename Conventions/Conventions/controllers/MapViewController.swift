//
//  MapViewController.swift
//  Conventions
//
//  Created by David Bahat on 3/7/16.
//  Copyright © 2016 Amai. All rights reserved.
//

class MapViewController: BaseViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    private var pageViewController: UIPageViewController!
    private var viewControllers = Array<MapFloorViewController>()
    private let areas = [
        MapArea(name: "מפה - מפלס עליון", image: UIImage(named: "Floor1")!),
        MapArea(name: "מפה - מפלס תחתון", image: UIImage(named: "Floor2")!),
        MapArea(name: "דוכנים - טרקלין אגם", image: UIImage(named: "Stands1")!),
        MapArea(name: "דוכנים - אולם פינקוס", image: UIImage(named: "Stands2")!),
        MapArea(name: "דוכנים - אולם כניסה", image: UIImage(named: "Stands3")!)
    ]
    
    // Not using the built in UIPageViewController page control since it's only supported for horizontal paging
    @IBOutlet private weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Vertical, options: nil);
        pageViewController.delegate = self;
        
        viewControllers = areas.map({area in
            let mapAreaViewController = storyboard!.instantiateViewControllerWithIdentifier(String(MapFloorViewController)) as! MapFloorViewController;
            mapAreaViewController.area = area
            return mapAreaViewController
        })
        
        pageViewController.setViewControllers([viewControllers[0]],
            direction: .Forward,
            animated: false,
            completion: {done in });
        
        for (index, viewController) in viewControllers.enumerate() {
            viewController.index = index
        }
        
        pageViewController.dataSource = self
        
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)

        pageViewController.didMoveToParentViewController(self);
        self.pageViewController = pageViewController;
        
        // Since pageControl is only horizontal, transform it to be vertical
        pageControl.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2));
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let vc = viewController as? MapFloorViewController {
            if vc.index == 0 {
                return nil
            }

            return viewControllers[vc.index - 1]
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let vc = viewController as? MapFloorViewController {
            if vc.index == viewControllers.count - 1 {
                return nil
            }

            return viewControllers[vc.index + 1]
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed {
            return
        }
        
        if let currentController = pageViewController.viewControllers?.first as? MapFloorViewController {
            pageControl.currentPage = currentController.index
        }
    }
}
