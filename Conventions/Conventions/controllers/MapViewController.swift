//
//  MapViewController.swift
//  Conventions
//
//  Created by David Bahat on 3/7/16.
//  Copyright © 2016 Amai. All rights reserved.
//

class MapViewController: BaseViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    @IBOutlet private weak var navigateToIroniBarItem: UIBarButtonItem!
    @IBOutlet private weak var navigateToEshkolBarItem: UIBarButtonItem!
    
    private var pageViewController: UIPageViewController!
    private var viewControllers = Array<MapFloorViewController>()
    private let areas = [
        MapArea(name: "עירוני - קומה 2", image: UIImage(named: "Ironi_floor2")!),
        MapArea(name: "עירוני - קומה 1", image: UIImage(named: "Ironi_floor1")!),
        MapArea(name: "אשכול - קומה 2", image: UIImage(named: "Eshkol_floor2")!),
        MapArea(name: "אשכול - קומה 1", image: UIImage(named: "Eshkol_floor1")!),
        MapArea(name: "מפת מתחם", image: UIImage(named: "Overview")!)
    ]
    
    // Not using the built in UIPageViewController page control since it's only supported for horizontal paging
    @IBOutlet private weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil);
        pageViewController.delegate = self;
        
        viewControllers = areas.map({area in
            let mapAreaViewController = storyboard!.instantiateViewController(withIdentifier: String(describing: MapFloorViewController.self)) as! MapFloorViewController;
            mapAreaViewController.area = area
            return mapAreaViewController
        })
        
        pageViewController.setViewControllers([viewControllers.last!],
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
        pageControl.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2));
        
        if areas.count == 1 {
            pageControl.isHidden = true
        }
        
        pageControl.currentPage = viewControllers.count - 1
        view.backgroundColor = Colors.mapBackgroundColor
        
        pageControl.pageIndicatorTintColor = Colors.mapIndicatorColor
        pageControl.currentPageIndicatorTintColor = Colors.mapIndicatorSelectedColor
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
            setBarItemsState(hidden: currentController.index < viewControllers.count - 1)
        }
    }
    
    @IBAction private func navigateToIroniWasPressed(_ sender: UIBarButtonItem) {
        pageControl.currentPage = 1
        pageViewController.setViewControllers([viewControllers[1]],
                                              direction: .reverse,
                                              animated: true,
                                              completion: nil)
        setBarItemsState(hidden: true)
    }
    
    @IBAction private func navigateToEshkolWasPressed(_ sender: UIBarButtonItem) {
        pageControl.currentPage = 3
        pageViewController.setViewControllers([viewControllers[3]],
                                              direction: .reverse,
                                              animated: true,
                                              completion: nil)
        setBarItemsState(hidden: true)
    }
    
    private func setBarItemsState(hidden: Bool) {
        if (hidden) {
            navigateToIroniBarItem.isEnabled = false
            navigateToIroniBarItem.tintColor = UIColor.clear
            navigateToEshkolBarItem.isEnabled = false
            navigateToEshkolBarItem.tintColor = UIColor.clear
        } else {
            navigateToIroniBarItem.isEnabled = true
            navigateToIroniBarItem.tintColor = nil
            navigateToEshkolBarItem.isEnabled = true
            navigateToEshkolBarItem.tintColor = nil
        }
    }
}
