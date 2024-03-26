//
//  SimulationViewModel.swift
//  VKPlagueSimulationTest
//
//  Created by Ильнур Закиров on 22.03.2024.
//

import Foundation
import Combine

protocol SimulationViewModelProtocol {
    var model: [[Person]] { get }
    var subject: CurrentValueSubject<[[Person]], Never> { get set }
    func healthyCount() -> Int
    func infectedCoumt() -> Int
    func infectPerson(at section: Int, _ index: Int)
    func runTimer()
}

class SimulationViewModel: SimulationViewModelProtocol {
    
    //MARK: - Свойства
    
    private (set) var model = [[Person]]()
    private let group = DispatchGroup()
    private let lock = NSLock()
    private let queue = DispatchQueue(label: "queue", qos: .userInitiated, attributes: .concurrent)
    private let configs: SimulatorModel
    var subject = CurrentValueSubject<[[Person]], Never>([])
    private var timer: Timer? = nil
    
    //MARK: - Инициализатор
    
    init(configs: SimulatorModel) {
        self.configs = configs
        setModel()
        setTimer()
    }
    
    //MARK: - Приватные методы
    
    ///Заполняет модель данными согласно вверденным настройкам симуляции
    private func setModel() {
        let line = Int(ceil(sqrt(Double(configs.groupSize))))
        for i in 0..<line {
            model.append([])
            for j in 0..<line {
                if line * i + j < configs.groupSize {
                    model[i].append(.init(id: i * 10 + j, isHealthy: true, address: (i,j)))
                } else {
                    break
                }
            }
            if model.last?.isEmpty ?? false {
                model.removeLast()
            }
        }
    }
    
    ///Устанавливает работу таймера
    private func setTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(configs.infectionTime), repeats: true, block: { _ in
            
            if self.isAllSick() {
                self.timer?.invalidate()
                self.timer = nil
            }
            
            let allNeighbors = [(-1,-1), (0, -1), (1,-1), (-1, 0), (1,0), (-1,1), (0, 1), (1,1)]
            let neighbors = allNeighbors.shuffled().suffix((0...self.configs.infectionFactor).randomElement() ?? 0)
            
            self.model.flatMap({$0}).filter{!$0.isHealthy}.forEach { person in
                for neighbor in neighbors {
                    self.queue.async { [weak self] in
                        guard let self else { return }
                        self.group.enter()
                        self.lock.lock()
                        if person.address.0 + neighbor.0 >= 0 &&
                            person.address.0 + neighbor.0 < self.model.count &&
                            person.address.1 + neighbor.1 >= 0 &&
                            person.address.1 + neighbor.1 < self.model[person.address.0 + neighbor.0].count &&
                            !person.isHealthy
                        {
                            infectPerson(at:person.address.0 + neighbor.0, person.address.1 + neighbor.1)
                        }
                        self.lock.unlock()
                        self.group.leave()
                    }
                }
            }
            self.group.notify(flags: .barrier ,queue: self.queue) { [weak self] in
                guard let self else { return }
                self.subject.send(self.model)
            }
        })
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    ///Проверяет все ли ячейки заражены
    private func isAllSick() -> Bool {
        return model.flatMap{$0}.allSatisfy{!$0.isHealthy}
    }
    
    ///Количество здоровых ячеек
    func healthyCount() -> Int {
        return model.flatMap{$0}.filter{$0.isHealthy}.count
    }
    
    ///Количество зараженных ячеек
    func infectedCoumt() -> Int {
        model.flatMap{$0}.filter{!$0.isHealthy}.count
    }
    
    ///Заразить ячейку
    func infectPerson(at section: Int, _ index: Int) {
        model[section][index].isHealthy = false
    }
    
    ///Запустить таймер
    func runTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.timer?.fire()
        }
    }
}
