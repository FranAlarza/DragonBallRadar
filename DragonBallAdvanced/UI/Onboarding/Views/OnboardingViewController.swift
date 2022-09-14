//
//  OnboardingViewController.swift
//  DragonBallAdvanced
//
//  Created by Fran Alarza on 6/9/22.
//

import UIKit


class OnboardingViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var OnboardingCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var principalButton: UIButton!
    
    // MARK: - CONSTANTS
    
    // MARK: - VARIABLES
    var viewModel: OnboardingViewModelProtocol?
    var userHasSeenTheTutorial = false
    private var currentPage = 0 {
        didSet {
            if currentPage < (viewModel?.slidesCount ?? 0) - 1 {
                principalButton.setTitle("Next", for: .normal)
            } else {
                principalButton.setTitle("Get Started", for: .normal)
            }
        }
    }
    
    // MARK: - CICLE OF LIFE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePrincipalCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    // MARK: - BUTTONS ACTIONS
    @IBAction func didPrincipalButtonTap(_ sender: Any) {
        if currentPage < (viewModel?.slidesCount ?? 0) - 1 {
            currentPage += 1
            let indexpath = IndexPath(item: currentPage, section: 0)
            OnboardingCollectionView.scrollToItem(at: indexpath, at: .centeredHorizontally, animated: true)
            pageControl.currentPage = currentPage
        } else {
            goToLogin()
            userHasSeenTheTutorial = true
            UserDefaultsHelper.saveItems(item: userHasSeenTheTutorial)
            
        }
    }
    
    // MARK: - FUNCTIONS
    func configurePrincipalCollectionView() {
        OnboardingCollectionView.delegate = self
        OnboardingCollectionView.dataSource = self
        let nib = UINib(nibName: OnboardingCollectionViewCell.identifier, bundle: nil)
        OnboardingCollectionView.register(nib, forCellWithReuseIdentifier: OnboardingCollectionViewCell.identifier)
    }
    
    func goToLogin() {
        let login = MainViewController()
        login.modalPresentationStyle = .fullScreen
        login.modalTransitionStyle = .flipHorizontal
        present(login, animated: true)
    }
    
    
}
// MARK: - Extensions

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.slidesCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as? OnboardingCollectionViewCell else { return UICollectionViewCell()}
        
        if let principalModel = viewModel?.getModels(with: indexPath) {
            cell.setData(with: principalModel)
        }
        
        return cell
    }
    
}

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        pageControl.currentPage = currentPage
    }
}
