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
        saveToDos()
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
                todos.forEach { todo in
                    print(todo.id)
                }
                self?.todos.removeAll()
                self?.todos = todos
            }
            .store(in: &cancellables)
    }
    
    private func saveToDos() {
        $todos
            .receive(on: DispatchQueue.global(qos: .background))
            .sink { [weak self] todos in
                self?.toDoRepository.saveToDos(todos)
            }
            .store(in: &cancellables)
    }
}
