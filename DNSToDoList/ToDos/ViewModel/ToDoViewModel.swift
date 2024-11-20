import Combine
import Foundation

class UserViewModel {
    @Published var user: ToDo?
    
    func fetchTodo() {
        self.user = ToDo(toDo: "Постирать белье", description: "Накопилась куча белья, поэтому идем его стирать", status: .inWork, dateAndTimeTheToDoWasCreated: Date.now)
    }
}
