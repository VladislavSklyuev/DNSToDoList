import Combine

class ToDosRepository: ToDoRepositoryProtocol {
    private let toDoService: ToDoServiceProtocol
    
    init(userService: ToDoServiceProtocol) {
        self.toDoService = userService
    }
    
    func getToDos() -> AnyPublisher<[ToDo], Error> {
        return toDoService.fetchToDos()
    }
    
    func saveToDos(_ todos: [ToDo]) {
        return toDoService.saveToDos(todos)
    }
}
