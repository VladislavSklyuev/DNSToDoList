import Combine

protocol ToDoRepositoryProtocol {
    func getToDos() -> AnyPublisher<[ToDo], Error>
    func saveToDos(_ todos: [ToDo])
}
