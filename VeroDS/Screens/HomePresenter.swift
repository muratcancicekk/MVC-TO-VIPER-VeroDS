//
//  HomePresenter.swift
//  VeroDS
//
//  Created by Murat Çiçek on 27.06.2023.
//

import Foundation
import UIKit
import Reachability
import AVFoundation

typealias HomePresenterDependencies = (
    interactor: HomeInteractor,
    router: HomeRoute
)

final class HomePresenter: Presenterable {
    
    var entites: HomeEntities
    var view: HomeViewInputs?
    let dependencies: HomePresenterDependencies
    
    init(view: HomeViewInputs,
         entites: HomeEntities,
         dependencies: HomePresenterDependencies) {
        self.view = view
        self.entites = entites
        self.dependencies = dependencies
    }
    
}
extension HomePresenter: HomeViewOutputs {
    func configureQrOperations() {
        let previewLayer = dependencies.interactor.avCapture()
        view?.previewLayerAddSublayer(previewLayer: previewLayer)
        dependencies.interactor.sessionStart()
        }
    
    func qrBtnClicked(controller: HomeViewController) {
        let previewLayer = dependencies.interactor.avCapture()
        view?.previewLayerAddSublayer(previewLayer: previewLayer)
        dependencies.interactor.sessionStart()
    }
    
    func searchData(searchText: String) {
        guard !searchText.isEmpty && dependencies.interactor.responseAPI != nil else {
            return
        }
        dependencies.interactor.homeData?.removeAll()
       
        // Search of all value
        guard let datas = dependencies.interactor.responseAPI else {return}
        for response in datas {
            
            if response.BusinessUnitKey?.range(of: searchText, options: .caseInsensitive) != nil {
                dependencies.interactor.homeData?.append(response)
                
            } else if response.businessUnit?.range(of: searchText, options: .caseInsensitive) != nil {
                dependencies.interactor.homeData?.append(response)
                
            } else if response.colorCode?.range(of: searchText, options: .caseInsensitive) != nil {
                dependencies.interactor.homeData?.append(response)
                
            } else if response.description?.range(of: searchText, options: .caseInsensitive) != nil {
                dependencies.interactor.homeData?.append(response)
                
            } else if response.parentTaskID?.range(of: searchText, options: .caseInsensitive) != nil {
                dependencies.interactor.homeData?.append(response)
                
            } else if response.preplanningBoardQuickSelect?.range(of: searchText, options: .caseInsensitive) != nil {
                dependencies.interactor.homeData?.append(response)
                
            } else if response.task?.range(of: searchText, options: .caseInsensitive) != nil {
                dependencies.interactor.homeData?.append(response)
                
            } else if response.title?.range(of: searchText, options: .caseInsensitive) != nil {
                dependencies.interactor.homeData?.append(response)
                
            } else if response.workingTime?.range(of: searchText, options: .caseInsensitive) != nil {
                dependencies.interactor.homeData?.append(response)
            }
        }
        
        if  dependencies.interactor.homeData?.isEmpty == true {
            guard let responceAPI = dependencies.interactor.responseAPI else { return }
            dependencies.interactor.homeData? = responceAPI
        }
        
        view?.tableViewReload(tableViewDataSource: HomeTableViewDataSource(interactor: dependencies.interactor))
    }
    
    func checkInternetConnection() {
        dependencies.interactor.checkInternetConnection { [weak self] in
            guard let interactor = self?.dependencies.interactor else { return }
            self?.view?.tableViewReload(tableViewDataSource: HomeTableViewDataSource(interactor: interactor))
        }
    }
    
    func viewDidLoad() {
        checkInternetConnection()
        view?.indicatorView(animate: true)
        view?.configure()
        view?.configureSearchView()
        view?.configureTableView()
        view?.configureQrOperations()
        dependencies.interactor.getAccessToken()
    }
}

extension HomePresenter: HomeInteractorOutputs {
    func onSuccessSearch(data: [HomeEntities.Response]?) {
        guard let data = data else { return }
        dependencies.interactor.homeData = data
        dependencies.interactor.responseAPI = data
        view?.indicatorView(animate: false)
        view?.tableViewReload(tableViewDataSource: HomeTableViewDataSource(interactor: dependencies.interactor))
    }
    
    func onErrorSearch(error: String) {
        print(error)
    }
}
