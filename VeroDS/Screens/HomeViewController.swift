//
//  ViewController.swift
//  VeroDS
//
//  Created by Berkan Gezgin on 6.04.2023.
//

import UIKit
import Reachability
import AVFoundation

final class HomeViewController: UIViewController {
    
    @IBOutlet private weak var qrBtn: UIButton!
    @IBOutlet private weak var searchTF: UITextField!
    @IBOutlet private weak var searchV: UIView!
    @IBOutlet private weak var resultTV: UITableView!
    
    var presenter: HomePresenter?
    var tableViewDataSource: TableViewDataSource?
    
    private let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    private let refreshControl = UIRefreshControl()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        HomeConfigurator.sharedInstance.configure(viewController: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        HomeConfigurator.sharedInstance.configure(viewController: self)
    }
    
    /// Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    @IBAction func qrBtnClicked(_ sender: Any) {
        presenter?.qrBtnClicked(controller: self)
    }
    
    @objc func closeKeyboard() {
        view.endEditing(true)
    }
    
    /// pull-to-refresh operations
    @objc func refresh(_ sender: UIRefreshControl) {
        presenter?.checkInternetConnection()
        sender.endRefreshing()
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataSource?.numberOfItems ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableViewDataSource?.itemCell(tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
    }
    
}
extension HomeViewController: HomeViewInputs {
    
    func metaDataSearch(searchText: String) {
        searchTF.text = searchText
    }
    
    func previewLayerAddSublayer(previewLayer: AVCaptureVideoPreviewLayer) {
        previewLayer.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer)
    }
    
    func indicatorView(animate: Bool) {
        DispatchQueue.main.async {
            self.resultTV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: animate ? 50 : 0, right: 0)
            _ = animate ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = !animate
        }
    }
    
    func configureQrOperations() {
        presenter?.configureQrOperations()
    }
    
    func configureTableView() {
        self.resultTV.delegate = self
        self.resultTV.dataSource = self
    }
    
    func configureSearchView() {
        searchV.setupView(borderColor: .red, borderWidth: 2.0, cornerRadius: 10)
        
        searchTF.setupSearchTextField(target: self, action: #selector(HomeViewController.textFieldDidChange(_:)), returnKeyType: .search, keyboardType: .webSearch, delegate: self, placeholder: "Search VerosDS...")
    }
    
    func tableViewReload(tableViewDataSource: TableViewDataSource) {
        self.tableViewDataSource = tableViewDataSource
        DispatchQueue.main.async { [weak self] in
            self?.resultTV.reloadData()
        }
    }
    
    func configure() {
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        resultTV.addSubview(refreshControl)
    }
    
}

extension HomeViewController: UITextFieldDelegate {
    
    /// Textfield operations
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTF.resignFirstResponder()
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        presenter?."textFieldDidChange(text: textField.text ?? "")
    }
    
}

extension HomeViewController: Viewable {}
