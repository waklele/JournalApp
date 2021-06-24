//
//  OnboardingViewController.swift
//  JournalApp
//
//  Created by Santo Michael Sihombing on 24/06/21.
//

import UIKit

class OnboardingViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pageCtr: UIPageControl!
    
    let onboardingSlide: [OnboardingSlide] = [
        OnboardingSlide(label: "Halo, aku Tama", description: "Selamat datang di Nozzle", image: #imageLiteral(resourceName: "Onboarding1")),
        OnboardingSlide(label: "Teman Belajar", description: "Aku akan nemenin kamu untuk mengisi catatan membaca sambil bermain puzzle", image: #imageLiteral(resourceName: "Onboarding2")),
        OnboardingSlide(label: "Nozzle", description: "Mencatat jadi lebih mudah", image: #imageLiteral(resourceName: "Onboarding3"))]
    
    var currentPage = 0 {
        didSet {
            pageCtr.currentPage = currentPage
            if currentPage == onboardingSlide.count - 1 {
                nextBtn.setTitle("Mari Mulai", for: .normal)
            } else {
                nextBtn.setTitle("Berikutnya", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextBtn.roundedButton(radius: 10)
        print("HEllo")
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @IBAction func nextBtnClicked(_ sender: Any) {
        
        if currentPage == onboardingSlide.count - 1 {
            print("Next")
//            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            notNewUser()
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    func notNewUser() {
        Core.shared.setIsNotNewUser()
        dismiss(animated: true, completion: nil)
    }
    
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingSlide.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        
        cell.setup(onboardingSlide[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        
    }
}
