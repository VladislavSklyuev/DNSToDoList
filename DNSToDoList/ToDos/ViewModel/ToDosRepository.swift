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
        toDoService.saveToDos(todos)
    }
    
    func deleteToDo(withId id: Int) {
        toDoService.deleteToDo(withId: id)
    }
}
