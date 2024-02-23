//
//  ViewController.swift
//  CollectionvViewDemo
//
//  Created by Bence Pattogato on 23/08/2021.
//

import UIKit

protocol WeatherView: AnyObject {
    func configure(with viewModel: WeatherViewModel)
}

final class WeatherViewController: UIViewController {
    var collectionView: UICollectionView! = nil


    private var dataSource: UICollectionViewDiffableDataSource<WeatherViewModel.Section, WeatherViewModel.Item>!
    private var viewModel: WeatherViewModel?
    // This is to be injected for clean code via the initialiser
    private let presenter: WeatherPresenter = WeatherPresenterImpl()
    var hourlyRegistration: UICollectionView.CellRegistration<HourlyEntryCollectionViewCell, WeatherViewModel.Item>!
    var dailyRegistration: UICollectionView.CellRegistration<DailyEntryCollectionViewCell, WeatherViewModel.Item>!
  

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureHierarchy()
        setupCellAndSupplementaryRegistrations()
        configureDataSource()
        presenter.viewLoaded(view: self)
    }
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: WeatherCollectionViewLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        
        /*
         collectionView.register(
             WeatherHeaderView.self,
             forSupplementaryViewOfKind: WeatherHeaderView.sectionHeaderElementKind,
             withReuseIdentifier: WeatherHeaderView.reuseIdentifier
         )
         */

        view.addSubview(collectionView)
    }
    
    
    func setupCellAndSupplementaryRegistrations() {
        hourlyRegistration =  .init(handler: {cell,indexPath,itemIdentifier in
            
            switch itemIdentifier {
            case .hour(let hour):
                cell.configure(with: hour)
            default:
                break
            }
        })
        
        dailyRegistration =  .init(handler: {cell,indexPath,itemIdentifier in
            switch itemIdentifier {
            case .day(let day):
                cell.configure(with: day)
            default:
                break
            }
        })
        /*
         
         headerRegistration = .init(supplementaryNib: SectionHeaderTextReusableView.nib, elementKind: UICollectionView.elementKindSectionHeader, handler: { (header, _, indexPath) in
             let title = self.backingStore[indexPath.section].title
             header.titleLabel.text = title
         })
         
         footerRegistration = .init(elementKind: UICollectionView.elementKindSectionFooter, handler: { (_, _, _) in })
         */
  
    }

    /*
     private func setupCollectionView() {
         collectionView.delegate = self
         collectionView.setCollectionViewLayout(WeatherCollectionViewLayout(), animated: false)
         collectionView.register(
             WeatherHeaderView.self,
             forSupplementaryViewOfKind: WeatherHeaderView.sectionHeaderElementKind,
             withReuseIdentifier: WeatherHeaderView.reuseIdentifier
         )
     }
     */

}

extension WeatherViewController: WeatherView {
    func configure(with viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        title = viewModel.title
        reloadData()
    }
}

// MARK: - Data handling

extension WeatherViewController {
    
    func configureDataSource() {
        /*
         
         dataSource = UICollectionViewDiffableDataSource<WeatherViewModel.Section, WeatherViewModel.Item>(collectionView: collectionView) {
             (collectionView: UICollectionView, indexPath: IndexPath, item: WeatherViewModel.Item) -> UICollectionViewCell? in
             guard let sectionIdentifier = self.dataSource.snapshot().sectionIdentifier(containingItem: item) else {
                 return nil
             }
             
             switch sectionIdentifier {
             case .hourly:
                 return collectionView.dequeueConfiguredReusableCell(using: self.hourlyRegistration, for: indexPath, item: item)
             case .daily:
                 return collectionView.dequeueConfiguredReusableCell(using: self.dailyRegistration, for: indexPath, item: item)
             }
         }*/

        /*
         dataSource = UICollectionViewDiffableDataSource<WeatherViewModel.Section, WeatherViewModel.Item>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
             guard let sectionIdentifier = self.dataSource.snapshot().sectionIdentifier(containingItem: item) else {
                 return nil
             }
             
             switch sectionIdentifier {
             case .hourly:
                 return collectionView.dequeueConfiguredReusableCell(using: self.hourlyRegistration, for: indexPath, item: item)
             case .daily:
                 return collectionView.dequeueConfiguredReusableCell(using: self.dailyRegistration, for: indexPath, item: item)
             }
         }
         */
        
        dataSource = UICollectionViewDiffableDataSource<WeatherViewModel.Section, WeatherViewModel.Item>(collectionView: collectionView, cellProvider: { (collectionView: UICollectionView, indexPath: IndexPath, item: WeatherViewModel.Item) -> UICollectionViewCell?  in
             guard let sectionIdentifier = self.dataSource.snapshot().sectionIdentifier(containingItem: item) else {
                 return nil
             }
            switch sectionIdentifier {
            case .hourly:
                return collectionView.dequeueConfiguredReusableCell(using: self.hourlyRegistration, for: indexPath, item: item)
            case .daily:
                return collectionView.dequeueConfiguredReusableCell(using: self.dailyRegistration, for: indexPath, item: item)
            }
        })
        
        

        /*
         
         dataSource.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
             if kind == UICollectionView.elementKindSectionHeader {
                 return collectionView.dequeueConfiguredReusableSupplementary(using: self.headerRegistration, for: indexPath)
             } else {
                 return collectionView.dequeueConfiguredReusableSupplementary(using: self.footerRegistration, for: indexPath)
             }
         }
         
         supplementaryViewProvider = { (
           collectionView: UICollectionView,
           kind: String,
           indexPath: IndexPath)
             -> UICollectionReusableView? in

           guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
             ofKind: kind,
             withReuseIdentifier: WeatherHeaderView.reuseIdentifier,
             for: indexPath) as? WeatherHeaderView else {
               fatalError("Cannot create header view")
           }

             supplementaryView.configure(
                 with: WeatherViewModel.Section.allCases[indexPath.section].headerName
             )
             
           return supplementaryView
         }
         */
        
        


    }
    
    private func makeSnapshot() -> NSDiffableDataSourceSnapshot<WeatherViewModel.Section, WeatherViewModel.Item> {
        var snapshot = NSDiffableDataSourceSnapshot<WeatherViewModel.Section, WeatherViewModel.Item>()

        viewModel?.sections.sorted(by: { $0.key.order < $1.key.order }).forEach { section, items in
            snapshot.appendSections([section])
            snapshot.appendItems(items, toSection: section)
        }

        return snapshot
    }

    private func reloadData() {
        dataSource.apply(makeSnapshot(), animatingDifferences: true)
    }
}

extension WeatherViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let item = dataSource.itemIdentifier(for: indexPath),
            case let WeatherViewModel.Item.day(day) = item
        else { return }

        presenter.selectDay(day)
    }
}
