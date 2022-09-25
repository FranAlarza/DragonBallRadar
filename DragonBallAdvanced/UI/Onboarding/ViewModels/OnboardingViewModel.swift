//
//  OnboardingViewModel.swift
//  DragonBallAdvanced
//
//  Created by Fran Alarza on 6/9/22.
//

import Foundation

protocol OnboardingViewModelProtocol {
    var slidesCount: Int { get }
    func getModels(with indexpath: IndexPath) -> PrincipalModel
}

class OnboardingViewModel {
    // MARK: - Variables
    weak var delegate: OnboardingViewController?
    private var currentPageCount: Int = 0
    var slides: [PrincipalModel] = [
        PrincipalModel(image: "Goku-1", title: "¡Hello Earthling!", description: "Wellcome to the Dragon Ball characters radar"),
        PrincipalModel(image: "Goku-2", title: "All Characters have disappeared", description: "Use your app to know the real location for each character"),
        PrincipalModel(image: "Goku-3", title: "Good Bye Earthling", description: "If you search well in your app maybe you will find my location.")
    ]
}

extension OnboardingViewModel: OnboardingViewModelProtocol {
    
    var slidesCount: Int {
        return slides.count
    }
    
    func getModels(with indexpath: IndexPath) -> PrincipalModel {
        return slides[indexpath.row]
    }
}
