import UIKit

protocol PageViewDelegate: class {

    /**
     Called when the number of pages is updated.

     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter count: the total number of pages.
     */
    func pageViewController(_ pageViewController: PageView,
                            didUpdatePageCount count: Int)

    /**
     Called when the current index is updated.

     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter index: the index of the currently visible page.
     */
    func pageViewController(_ pageViewController: PageView,
                            didUpdatePageIndex index: Int)

}

class PageView: UIPageViewController {
    weak var pageViewDelegate: PageViewDelegate?
    var arrayChildView = [UIViewController]()

    var infiniteScroll = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.dataSource = self
        self.delegate = self

        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func reloadPageView() {
        pageViewDelegate?.pageViewController(self, didUpdatePageCount: arrayChildView.count)
        if let initialViewController = arrayChildView.first {
            scrollToViewController(initialViewController)
        }
    }

    /**
     Scrolls to the next view controller.
     */
    func scrollToNextViewController() {
        if let visibleViewController = viewControllers?.first,
            let nextViewController = pageViewController(self,
                                                        viewControllerAfter: visibleViewController) {
            scrollToViewController(nextViewController)
        }
    }

    /**
     Scrolls to the view controller at the given index. Automatically calculates
     the direction.

     - parameter newIndex: the new index to scroll to
     */
    func scrollToViewController(index newIndex: Int) {
        if let firstViewController = viewControllers?.first,
            let currentIndex = self.arrayChildView.index(of: firstViewController) {
            let direction: UIPageViewControllerNavigationDirection = newIndex >= currentIndex ? .forward : .reverse
            let nextViewController = self.arrayChildView[newIndex]
            scrollToViewController(nextViewController, direction: direction)
        }
    }

    /**
     Scrolls to the given 'viewController' page.

     - parameter viewController: the view controller to show.
     */
    fileprivate func scrollToViewController(_ viewController: UIViewController,
                                            direction: UIPageViewControllerNavigationDirection = .forward) {

        setViewControllers([viewController],
                           direction: direction,
                           animated: true,
                           completion: { (finished) -> Void in
                            // Setting the view controller programmatically does not fire
                            // any delegate methods, so we have to manually notify the
                            // 'tutorialDelegate' of the new index.
                            if finished {
                                self.notifyDelegateOfNewIndex()
                            }
        })
    }

    /**
     Notifies '_tutorialDelegate' that the current page index was updated.
     */
    fileprivate func notifyDelegateOfNewIndex() {
        if let firstViewController = viewControllers?.first,
            let index = self.arrayChildView.index(of: firstViewController) {
            self.pageViewDelegate?.pageViewController(self, didUpdatePageIndex: index)
        }
    }
}

extension PageView: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.arrayChildView.index(of: viewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1

        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            if self.infiniteScroll == true {
                return arrayChildView.last
            } else {
                return nil
            }
        }

        guard arrayChildView.count > previousIndex else {
            return nil
        }
        return self.arrayChildView[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = arrayChildView.index(of: viewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = arrayChildView.count

        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            if self.infiniteScroll == true {
                return arrayChildView.first
            } else {
                return nil
            }
        }

        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        return arrayChildView[nextIndex]
    }

}

extension PageView: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        notifyDelegateOfNewIndex()
    }

}
