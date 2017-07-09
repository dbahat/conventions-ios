//
//  MapViewController.swift
//  Conventions
//
//  Created by David Bahat on 3/7/16.
//  Copyright © 2016 Amai. All rights reserved.
//

class MapViewController: BaseViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    fileprivate var pageViewController: UIPageViewController!
    fileprivate var viewControllers = Array<MapFloorViewController>()
    fileprivate let areas = [
        MapArea(name: "מפת התמצאות", image: UIImage(named: "Floor1")!)
    ]
    
    // Not using the built in UIPageViewController page control since it's only supported for horizontal paging
    @IBOutlet fileprivate weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil);
        pageViewController.delegate = self;
        
        viewControllers = areas.map({area in
            let mapAreaViewController = storyboard!.instantiateViewController(withIdentifier: String(describing: MapFloorViewController.self)) as! MapFloorViewController;
            mapAreaViewController.area = area
            return mapAreaViewController
        })
        
        pageViewController.setViewControllers([viewControllers[0]],
            direction: .forward,
            animated: false,
            completion: {done in });
        
        for (index, viewController) in viewControllers.enumerated() {
            viewController.index = index
        }
        
        pageViewController.dataSource = self
        
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)

        pageViewController.didMove(toParentViewController: self);
        self.pageViewController = pageViewController;
        
        // Since pageControl is only horizontal, transform it to be vertical
        pageControl.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2));
        
        if areas.count == 1 {
            pageControl.isHidden = true
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let vc = viewController as? MapFloorViewController {
            if vc.index == 0 {
                return nil
            }

            return viewControllers[vc.index - 1]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let vc = viewController as? MapFloorViewController {
            if vc.index == viewControllers.count - 1 {
                return nil
            }

            return viewControllers[vc.index + 1]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed {
            return
        }
        
        if let currentController = pageViewController.viewControllers?.first as? MapFloorViewController {
            pageControl.currentPage = currentController.index
        }
    }
}
