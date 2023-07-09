//
//  HomeTableViewDataSource.swift
//  VeroDS
//
//  Created by Murat Çiçek on 27.06.2023.
//

import Foundation
import UIKit

final class HomeTableViewDataSource: TableViewDataSource {
    
    private var interactor: HomeInteractor!

    init(interactor: HomeInteractor) {
        self.interactor = interactor
    }
    
    var numberOfItems: Int {
        return interactor.homeData?.count ?? 0
    }
    
    func itemCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as! ResultTableViewCell
        cell.setupUI(data: interactor.homeData?[indexPath.row])
        return cell
    }
    
}
