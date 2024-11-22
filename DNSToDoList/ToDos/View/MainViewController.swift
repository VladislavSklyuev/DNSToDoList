import UIKit
import Combine

// TODO: - Таблицу отдельным файлом
final class MainViewController: UIViewController {
    
    private var viewModel: ToDosViewModel = ToDosViewModel(toDoRepository: ToDosRepository(userService: CoreDataManager(coreDataStack: CoreDataStack())))
    private var cancellables = Set<AnyCancellable>()

    // TODO: - строковые литералы в константы
    private enum Constants {
        static let heightForRowAt: CGFloat = 80
    }
    
    @Autolayout private var titleLabel: UILabel = {
        $0.text = "Задачи"
        $0.font = UIFont.boldSystemFont(ofSize: 28)
        $0.textAlignment = .left
        $0.textColor = .white
        return $0
    }(UILabel())
    
    @Autolayout private var buttonToAddNewTodo: UIButton = {
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
        return $0
    }(UIButton())
    
    lazy var tableView: UITableView = {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .black
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(ToDoCell.self, forCellReuseIdentifier: ToDoCell.reuseIdentifier)
        return $0
    }(UITableView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setConstraints()
        creatingNewTodo()
        setupBindings()
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        tableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let location = gesture.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: location) {
                
                if let cell = tableView.cellForRow(at: indexPath) {
                    cell.backgroundColor = .gray
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.showAlert(forItemAt: indexPath)
                }
            }

            let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
            feedbackGenerator.prepare()
            feedbackGenerator.impactOccurred()
        } else {
            let location = gesture.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: location) {
                if let cell = tableView.cellForRow(at: indexPath) {
                    cell.backgroundColor = .black
                }
            }
        }
    }
    
    //TODO: Переделать на отдельную View с выбором детализации и изменения статуса
    private func showAlert(forItemAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Задача", message: "\(viewModel.todos[indexPath.row].toDo), \(viewModel.todos[indexPath.row].dateAndTimeTheToDoWasCreated)", preferredStyle: .alert)
        
        let currentStatusToDo = viewModel.todos[indexPath.row].status
        
        switch currentStatusToDo {
        case .newToDo:
            let okAction = UIAlertAction(title: "Взять в работу", style: .default) { _ in
                // TODO: Реализация логики замены статуса
            }
            
            let deleteAction = UIAlertAction(title: "Удалить задачу", style: .destructive) { _ in
                // TODO: Реализация логики замены статуса
            }
            
            alert.addAction(okAction)
            alert.addAction(deleteAction)
        case .inWork:
            let completedToDo = UIAlertAction(title: "Выполнить", style: .default) { _ in
                // TODO: Реализация логики замены статуса
            }
            alert.addAction(completedToDo)
        case .completed:
            let completedToDo = UIAlertAction(title: "Ок", style: .default) { _ in
                // TODO: Реализация логики замены статуса
            }
            alert.addAction(completedToDo)
            break
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    private func setConstraints() {
        view.addSubview(titleLabel)
        view.addSubview(buttonToAddNewTodo)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            
            buttonToAddNewTodo.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            buttonToAddNewTodo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
            tableView.topAnchor.constraint(equalTo: buttonToAddNewTodo.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}


private extension MainViewController {
    
    // MARK: - Добавление новой задачи
    func creatingNewTodo() {
        let action = UIAction { _ in
            let alert = UIAlertController(title: "Новая задача", message: "Создайте новую задачу", preferredStyle: .alert)
        
            alert.addTextField { tf in
                tf.placeholder = "Задача"
                tf.keyboardType = .default
            }
            alert.addTextField { tf in
                tf.placeholder = "Описание задачи"
                tf.keyboardType = .default
            }
            
            let okAction = UIAlertAction(title: "Добавить", style: .default) { _ in
                guard let todo = alert.textFields![0].text,
                      let description = alert.textFields![1].text else { return }
                guard !todo.isEmpty && !description.isEmpty else { return } // TODO: Можно придумать логику при отсутствии значений
                
                // TODO: Возможно убрать во ViewModel
                let newTodo = ToDo(id: Int.random(in: 1...999), toDo: todo, description: description, status: .completed, dateAndTimeTheToDoWasCreated: .now)
                self.viewModel.todos.append(newTodo)
                self.viewModel.saveToDos()
            }
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true)
        }
        buttonToAddNewTodo.addAction(action, for: .touchUpInside)
    }
    
    // MARK: - Обновление таблицы
    func setupBindings() {
        viewModel.$todos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.todos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoCell.reuseIdentifier, for: indexPath) as? ToDoCell else {
            return UITableViewCell()
        }
        
        cell.configureCell(toDoTitle: viewModel.todos[indexPath.row].toDo, toDoStatus: viewModel.todos[indexPath.row].status.rawValue, date: viewModel.todos[indexPath.row].dateAndTimeTheToDoWasCreated)
        cell.backgroundColor = .black
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    // Высота ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.heightForRowAt
    }
    
    // Обработка выбора ячейки
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Выбрано: \(viewModel.todos[indexPath.row])")
    }
    
    // Удаление ячейки по свайпу
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemToDelete = viewModel.todos[indexPath.row]
            guard let index = viewModel.todos.firstIndex(of: itemToDelete) else { return }
            viewModel.todos.remove(at: index)
            viewModel.deleteToDo(withId: itemToDelete.id)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
