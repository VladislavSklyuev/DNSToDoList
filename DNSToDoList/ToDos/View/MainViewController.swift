import UIKit

// TODO: - Таблицу отдельным файлом
final class MainViewController: UIViewController {
    
    private var toDos = ToDo.mock

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

// MARK: - Добавление новой задачи
private extension MainViewController {
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
            
                let newTodo = ToDo(toDo: todo, description: description, status: .newToDo, dateAndTimeTheToDoWasCreated: .now)
                self.toDos.append(newTodo)
                
                self.tableView.reloadData()
            }
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true)
        }
        buttonToAddNewTodo.addAction(action, for: .touchUpInside)
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoCell.reuseIdentifier, for: indexPath) as? ToDoCell else {
            return UITableViewCell()
        }
        
        cell.configure(toDoTitle: toDos[indexPath.row].toDo, toDoStatus: toDos[indexPath.row].status.rawValue, date: toDos[indexPath.row].dateAndTimeTheToDoWasCreated)
        cell.backgroundColor = .black
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
        
    }
}
