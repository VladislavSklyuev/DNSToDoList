import Combine
import Foundation

final class ToDosViewModel {
    @Published var todos: [ToDo] = []
    @Published var errorMessage: String?
    
    private let toDoRepository: ToDoRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(toDoRepository: ToDoRepositoryProtocol) {
        self.toDoRepository = toDoRepository
        fetchToDos()
        errorBinding()
    }
    
    private func fetchToDos() {
        toDoRepository
            .getToDos()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                default: break
                }
            } receiveValue: { [weak self] todos in
                self?.todos.removeAll()
                self?.todos = todos
            }
            .store(in: &cancellables)
    }
    
    func errorBinding() {
        $errorMessage
            .receive(on: DispatchQueue.main)
            .sink { errorMessage in
                if errorMessage != nil {
                    print("Error: \(String(describing: errorMessage))")
                }
            }
            .store(in: &cancellables)
    }
    
    func creatingNewTodo(_ todo: String?, _ description: String?) {
        guard let todo = todo,
              let description = description else { return }
        guard !todo.isEmpty && !description.isEmpty else { return }
        let newTodo = ToDo(id: Int.random(in: 1...999), toDo: todo, description: description, status: .newToDo, dateAndTimeTheToDoWasCreated: .now)
        todos.append(newTodo)
        saveToDo()
    }
    
    func changeStatusFor(_ todo: ToDo, _ index: Int) {
        switch todo.status {
        case .newToDo:
            todos[index].status = .inWork
            update(todos[index])
        case .inWork:
            todos[index].status = .completed
            update(todos[index])
        case .completed:
            break
        }
    }
    func saveToDo() {
        guard let item = todos.last else { return }
        toDoRepository.saveToDo(item)
    }
    
    func delete(_ todo: ToDo) {
        guard let index = todos.firstIndex(of: todo) else { return }
        todos.remove(at: index)
        toDoRepository.deleteToDo(withId: todo.id)
    }
    
    func update(_ todo: ToDo) {
        toDoRepository.updateTodo(todo)
    }
}
