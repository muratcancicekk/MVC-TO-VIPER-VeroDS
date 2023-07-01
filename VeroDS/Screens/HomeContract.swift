//
//  HomeContract.swift
//  VeroDS
//
//  Created by Murat Çiçek on 27.06.2023.
//

import Foundation
import AVFoundation
import UIKit

protocol HomeViewInputs: AnyObject {
    func configure()
    func tableViewReload(tableViewDataSource: TableViewDataSource)
    func configureSearchView()
    func configureTableView()
    func configureQrOperations()
    func indicatorView(animate: Bool)
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection)
    func previewLayerAddSublayer(previewLayer: AVCaptureVideoPreviewLayer)
}
protocol HomeViewOutputs: AnyObject {
    func viewDidLoad()
    func checkInternetConnection()
    func searchData(searchText: String)
    func qrBtnClicked(controller: HomeViewController)
    func configureQrOperations()
    
}
protocol HomeInteractorOutputs: AnyObject {
    func onSuccessSearch(data: [HomeEntities.Response]?)
    func onErrorSearch(error: String)
}
protocol HomeInteractorInputs: AnyObject {
    func getAccessToken()
    func getLocalDataURL()
    func getDatas()
    func processData(data: Data, success: @escaping (() -> Void?))
    func avCapture() -> AVCaptureVideoPreviewLayer
    func sessionStart()
    func sessionStop()
    var session: AVCaptureSession? { get }
    func checkInternetConnection(tableViewReload: @escaping (() -> Void))
}
protocol HomeDataStore: AnyObject {
    var localDataURL: URL? { get set }
    var accessToken: String? { get set }
    var homeData: [HomeEntities.Response]? { get set }
    var searchData: [HomeEntities.Response]? { get set }
    var responseAPI: [HomeEntities.Response]? { get set }
}
