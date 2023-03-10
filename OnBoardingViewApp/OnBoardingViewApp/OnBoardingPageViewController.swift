//
//  OnBoardingPageViewController.swift
//  OnBoardingViewApp
//
//  Created by 이치훈 on 2023/02/07.
//

import UIKit

class OnBoardingPageViewController: UIPageViewController {

    var pages = [UIViewController]()
     
    var bottomButtonMargin: NSLayoutConstraint?
    
    var pageControl = UIPageControl()
    
    let startIndex: Int = 0
    
    var currentIndex = 0{
        didSet{
            self.pageControl.currentPage = currentIndex
        }
    }
    
    func makePageVC(){
        let itemVC1 = OnBoardingItemViewController(nibName: "OnBoardingItemViewController", bundle: nil)
        itemVC1.topImagePara = UIImage(named: "Onboarding1")
        itemVC1.mainTitlePara = "Focus on your ideal buyer"
        itemVC1.descriptionPara = "When you write a product description with a huge crowd of buyers in mind, your descriptions become wishy-washy and you end up addressing no one at all"
        
        let itemVC2 = OnBoardingItemViewController(nibName: "OnBoardingItemViewController", bundle: nil)
        itemVC2.topImagePara = UIImage(named: "Onboarding2")
        itemVC2.mainTitlePara = "Entice with benefits"
        itemVC2.descriptionPara = "When we sell our own products, we get excited about individual product features and specifications. We live and breathe our company, our website, and our products."
        
        let itemVC3 = OnBoardingItemViewController(nibName: "OnBoardingItemViewController", bundle: nil)
        itemVC3.topImagePara = UIImage(named: "Onboarding3")
        itemVC3.mainTitlePara = "Avoid yeah, yeah phrases"
        itemVC3.descriptionPara = "When we're stuck for words and don't know what else to add to our product description, we often add something bland like \"excellent product quality\"."
        
        pages.append(itemVC1)
        pages.append(itemVC2)
        pages.append(itemVC3)
        
        setViewControllers([itemVC1], direction: .forward, animated: true)
        //UIPageViewController에 현재 화면 세팅, pageControl 화면전환 logic에 사용됨
        
        self.dataSource = self
        self.delegate = self
    }
    
    func makePageControl(){
        self.view.addSubview(pageControl)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .darkGray
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = startIndex
        
        pageControl.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -55).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        //pageControl.isUserInteractionEnabled = false
        pageControl.addTarget(self, action: #selector(pageControlTapped), for: .valueChanged)
        
    }
    
    func makeBottomButton(){
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(dismissPageVC), for: .touchUpInside)
        
        self.view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        bottomButtonMargin = button.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        bottomButtonMargin?.isActive = true //버튼의 속성값을 변경하기위해 bottomButtonMargin에 값을 대입함
        //bottomButton AutoLayout 속성 설정
        
        
        self.hideButton()
        NSLog("did calledhideButton at makeButton")
    }
    
    @objc func pageControlTapped(sender: UIPageControl){
        if sender.currentPage > currentIndex{
            self.setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true)
        }else{
            self.setViewControllers([pages[sender.currentPage]], direction: .reverse, animated: true)
        }
        
        self.currentIndex = sender.currentPage
        
        self.buttonPresentationStyle()
    }
    
    @objc func dismissPageVC(){
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.makePageVC()
        self.makeBottomButton()
        self.makePageControl()
    }

    

}
//MARK: - UIPageViewControllerDataSource
extension OnBoardingPageViewController: UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        //현재 viewcontroller의 index 반환
        guard let currentIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        self.currentIndex = currentIndex
        
        if currentIndex == 0 {
            return pages.last
        }else{
            return pages[currentIndex - 1]
        }
    
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        self.currentIndex = currentIndex
        
        if currentIndex == (pages.count - 1) {
            return pages.first
        }else{
            return pages[currentIndex + 1]
        }
    }
    
    
}

extension OnBoardingPageViewController: UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        NSLog("UIPageViewControllerDelegate Logic started")
        guard let currentVC = pageViewController.viewControllers?.first else {return}
        
        guard let currentIndex = pages.firstIndex(of: currentVC) else {return}
        
        self.currentIndex = currentIndex
        
        buttonPresentationStyle()
    }
    
    func buttonPresentationStyle(){
        if currentIndex == pages.count - 1 {
            self.showButton()
            NSLog("did called showButton at DelegateLogic")
        }else{
            self.hideButton()
            NSLog("did called hideButton at DelegateLogic")
        }
        
        UIView.animate(withDuration: 0.25){
            self.view.layoutIfNeeded()
        }
    }
    
    func showButton(){
        bottomButtonMargin?.constant = 0
        NSLog("call showButton")
    }
    
    func hideButton(){
        bottomButtonMargin?.constant = 100
    }
}
