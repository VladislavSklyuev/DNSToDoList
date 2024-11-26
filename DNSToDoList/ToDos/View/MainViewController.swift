import UIKit
import Combine

final class MainViewController: UIViewController {
    
    var viewModel: ToDosViewModel!
    private var cancellables = Set<AnyCancellable>()

    private enum SizeConstants {
        static let heightForRowAt: CGFloat = 80
        static let titleLabelTopAnchor: CGFloat = 24
        static let titleLabelLeadingAnchor: CGFloat = 12
        static let buttonToAddNewTodoTrailingAnchor: CGFloat = -12
        static let tableViewTopAnchor: CGFloat = 8
        static let tableViewLeadingAnchor: CGFloat = 8
        static let tableViewTrailingAnchor: CGFloat = -8
        static let titleLabelFontSize: CGFloat = 28
    }
    
    private enum NamesTodoActionButtons {
        static let getToWork = "Взять в работу"
        static let deleteTodo = "Удалить задачу"
        static let cancel = "Отменить"
        static let execute = "Выполнить"
        static let addTodo = "Добавить"
        static let ok = "Oк"
        static let newToDo = "Новая задача"
        static let createNewToDo = "Создайте новую задачу"
    }
    
    private enum ElementNames {
        static let todoTitleLabel = "Задачи"
        static let todoTextFieldTitle = "Задача"
        static let buttonToAddNewTodoImageName = "square.and.pencil"
        static let descriptionTodo = "Описание задачи"
    }
    
    @Autolayout private var titleLabel: UILabel = {
        $0.text = ElementNames.todoTitleLabel
        $0.font = UIFont.boldSystemFont(ofSize: SizeConstants.titleLabelFontSize)
        $0.textAlignment = .left
        $0.textColor = .black
        return $0
    }(UILabel())
    
    @Autolayout private var buttonToAddNewTodo: UIButton = {
        $0.setImage(UIImage(systemName: ElementNames.buttonToAddNewTodoImageName), for: .normal)
        return $0
    }(UIButton())
    
    lazy var tableView: UITableView = {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(ToDoCell.self, forCellReuseIdentifier: ToDoCell.reuseIdentifier)
        return $0
    }(UITableView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setConstraints()
        creatingNewTodo()
        setupBindings()
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        tableView.addGestureRecognizer(longPressGesture)
    }
    
    // MARK: - Обработка долгого нажатия на ячейку
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let location = gesture.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: location) {
                
                if let cell = tableView.cellForRow(at: indexPath) {
                    cell.backgroundColor = .lightGray
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
                    cell.backgroundColor = .white
                }
            }
        }
    }
    
    private func showAlert(forItemAt indexPath: IndexPath) {
        let alertTitle = viewModel.todos[indexPath.row].toDo
        let alertMessage = "\(viewModel.todos[indexPath.row].description)\n\(viewModel.todos[indexPath.row].dateAndTimeTheToDoWasCreated.toString())"
        
        let alert = UIAlertController(title: alertTitle,
                                      message: alertMessage,
                                      preferredStyle: .alert)
        
        let selectedTodo = viewModel.todos[indexPath.row]
        
        switch selectedTodo.status {
            
        case .newToDo:
            
            let takeOnTodo = UIAlertAction(title: NamesTodoActionButtons.getToWork, style: .default) { _ in
                var todo = self.viewModel.todos[indexPath.row]
                todo.status = .inWork
                self.viewModel.todos[indexPath.row].status = .inWork
                self.viewModel.updateToDo(todo)
            }
            
            let deleteAction = UIAlertAction(title: NamesTodoActionButtons.deleteTodo, style: .destructive) { _ in
                guard let index = self.viewModel.todos.firstIndex(of: selectedTodo) else { return }
                self.viewModel.todos.remove(at: index)
                self.viewModel.deleteToDo(withId: selectedTodo.id)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            let cancelAction = UIAlertAction(title: NamesTodoActionButtons.cancel, style: .cancel) { _ in }
            
            alert.addAction(takeOnTodo)
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            
        case .inWork:

            let completeTheToDo = UIAlertAction(title: NamesTodoActionButtons.execute, style: .default) { _ in
                self.viewModel.todos[indexPath.row].status = .completed
                var todo = self.viewModel.todos[indexPath.row]
                todo.status = .completed
                self.viewModel.updateToDo(todo)
            }
            
            let cancelAction = UIAlertAction(title: NamesTodoActionButtons.cancel, style: .cancel) { _ in }
            alert.addAction(completeTheToDo)
            alert.addAction(cancelAction)
            
        case .completed:
            
            let okAction = UIAlertAction(title: NamesTodoActionButtons.ok, style: .default) { _ in }
            alert.addAction(okAction)
        }
        present(alert, animated: true)
    }
    
    private func setConstraints() {
        view.addSubview(titleLabel)
        view.addSubview(buttonToAddNewTodo)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: SizeConstants.titleLabelTopAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SizeConstants.titleLabelLeadingAnchor),
            
            buttonToAddNewTodo.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            buttonToAddNewTodo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: SizeConstants.buttonToAddNewTodoTrailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: buttonToAddNewTodo.bottomAnchor, constant: SizeConstants.tableViewTopAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SizeConstants.tableViewLeadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: SizeConstants.tableViewTrailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}


private extension MainViewController {
    
    // MARK: - Добавление новой задачи
    func creatingNewTodo() {
        let action = UIAction { _ in
            let alert = UIAlertController(title: NamesTodoActionButtons.newToDo, message: NamesTodoActionButtons.createNewToDo, preferredStyle: .alert)
        
            alert.addTextField { textField in
                textField.placeholder = ElementNames.todoTextFieldTitle
                textField.keyboardType = .default
            }
            alert.addTextField { textField in
                textField.placeholder = ElementNames.descriptionTodo
                textField.keyboardType = .default
            }
            
            let okAction = UIAlertAction(title: NamesTodoActionButtons.addTodo, style: .default) { _ in
                guard let todo = alert.textFields![0].text,
                      let description = alert.textFields![1].text else { return }
                guard !todo.isEmpty && !description.isEmpty else { return } // TODO: Можно придумать логику при отсутствии значений
                
                let newTodo = ToDo(id: Int.random(in: 1...999), toDo: todo, description: description, status: .newToDo, dateAndTimeTheToDoWasCreated: .now)
                self.viewModel.todos.append(newTodo)
                self.viewModel.saveToDo()
            }
            
            let cancelAction = UIAlertAction(title: NamesTodoActionButtons.cancel, style: .cancel)
            
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
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    // Высота ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SizeConstants.heightForRowAt
    }
}
