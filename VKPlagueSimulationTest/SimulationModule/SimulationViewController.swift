import UIKit
import Combine

class SimulationViewController: UIViewController {
    
    //MARK: - Свойства не наследники UIView
    private var viewModel: SimulationViewModelProtocol
    private let group = DispatchGroup()
    private var dataSource: UICollectionViewDiffableDataSource<Int, Person>?
    private var snapshot: NSDiffableDataSourceSnapshot<Int, Person>?
    private var storage = Set<AnyCancellable>()
    private var scale: CGFloat = 1
    
    private lazy var layout = UICollectionViewCompositionalLayout {
        [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
        guard let self else { return nil}
        
        let itemWidth = 1 / CGFloat(self.viewModel.model[0].count)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemWidth),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 5, bottom: 10, trailing: 5)
        
        
        let groupWidth = CGFloat(self.viewModel.model[0].count) / 10
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupWidth * self.scale),
                                               heightDimension: .fractionalWidth(0.15 * self.scale))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    // MARK: - Свойства наследники UIView
    private let countersView = CounterView()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.maximumZoomScale = 4
        view.minimumZoomScale = 0.1
        return view
    }()
    
    //MARK: init
    
    init(viewModel: SimulationViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Методы
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setDataSource()
        binding()
        addGesture()
    }
    
    /// Настройка паблишера
    private func binding() {
        viewModel.subject
            .sink { [weak self] model in
                var sections = Set<Int>()
                for i in 0..<model.count {
                    for j in 0..<model[i].count {
                        if model[i][j].isHealthy == false {
                            self?.group.enter()
                            sections.insert(i)
                            self?.group.leave()
                        }
                    }
                }
                self?.group.notify(queue: .main) { [weak self] in
                    self?.reloadTableView(sectionId: Array(sections))
                    let hc = self?.viewModel.healthyCount() ?? 0
                    let ic = self?.viewModel.infectedCoumt() ?? 0
                    self?.countersView.updateCounters(healthy: hc, infected: ic)
                }
            }
            .store(in: &storage)
    }
    
    ///Добавление subViews и настройка лэйаута
    private func setupViews() {
        collectionView.delegate = self
        view.addSubview(countersView)
        view.addSubview(collectionView)
        [
            countersView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            countersView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            countersView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: countersView.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ].forEach{$0.isActive = true}
    }
    
    ///Настройка датаСорса
    private func setDataSource() {
        
        let regitration = UICollectionView.CellRegistration<UICollectionViewCell, Person> { [weak self] cell, indexPath, itemIdentifier in
            guard let self else { return }
            cell.backgroundColor = self.viewModel.model[indexPath.section][indexPath.item].isHealthy ? .green : .red
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: regitration,
                                                                for: indexPath,
                                                                item: itemIdentifier)
        })
        
        snapshot = NSDiffableDataSourceSnapshot<Int, Person>()
        for (i, v) in viewModel.model.enumerated() {
            snapshot?.appendSections([i])
            snapshot?.appendItems(v)
        }
        guard let snapshot else { return }
        dataSource?.apply(snapshot)
    }
    
    ///Перезагрузка таблицы
    private func reloadTableView(sectionId: [Int]) {
        snapshot?.reloadSections(sectionId)
        dataSource?.apply(snapshot!)
    }
    
    ///Добавление жеста на коллекцию
    private func addGesture() {
        let gesture = UIPinchGestureRecognizer(target: self, action: #selector(viewPicnhed(sender:)))
        collectionView.addGestureRecognizer(gesture)
    }
    
    ///Логика жеста (увеличивает/уменьшает содержимое коллекции)
    @objc
    func viewPicnhed(sender: UIPinchGestureRecognizer) {
        var newScale: CGFloat = 1
        switch sender.state {
        case .began:
            newScale = scale
        case .changed:
            scale = newScale * sender.scale
            layout.invalidateLayout()
        default:
            break
        }
    }
    

}

extension SimulationViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.infectPerson(at: indexPath.section, indexPath.item)
        reloadTableView(sectionId: [indexPath.section])
        countersView.updateCounters(healthy: viewModel.healthyCount(), infected: viewModel.infectedCoumt())
        viewModel.runTimer()
    }
    
}
