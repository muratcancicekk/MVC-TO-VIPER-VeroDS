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
    
    var view: HomeViewInputs?
    let dependencies: HomePresenterDependencies
    
    init(view: HomeViewInputs,
         entities: HomeEntities,
         dependencies: HomePresenterDependencies) {
        self.view = view
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
    
    func textFieldDidChange(text: String) {
        dependencies.interactor.searchData(searchText: text)
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
    
    func metaDataOutput(data: String) {
        view?.metaDataSearch(searchText: data)
        view?.tableViewReload(tableViewDataSource: HomeTableViewDataSource(interactor: dependencies.interactor))
    }
    
    func onSuccessSearch(data: [HomeEntities.Response]?) {
        guard let data = data else { return }
        dependencies.interactor.homeData = data
        dependencies.interactor.responseAPI = data
        view?.indicatorView(animate: false)
        view?.tableViewReload(tableViewDataSource: HomeTableViewDataSource(interactor: dependencies.interactor))
    }
    
    func onErrorSearch(error: String) {
        Alerts().defaultAlert(title: "Erro", message: "Error")
    }
    
}
