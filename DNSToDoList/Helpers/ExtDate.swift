import Foundation

extension Date {
    func convert(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        let dateString = formatter.string(from: date)
        return dateString
    }
}
