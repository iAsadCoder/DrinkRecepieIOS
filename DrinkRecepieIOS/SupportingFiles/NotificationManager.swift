//
//  NotificationManager.swift
//  DrinkRecepieIOS
//
//  Created by iAsad on 09/08/2024.
//

import UserNotifications
import CoreData
import Network
import SDWebImage

class NotificationManager {
    static let shared = NotificationManager()
    private init() {}

//    func scheduleDailyNotification() {
//        let content = UNMutableNotificationContent()
//        content.title = "Drink Suggestion"
//        content.body = "Check out a random drink recipe!"
//        content.sound = .default
//        
//        let triggerDate = DateComponents(hour: 14, minute: 0)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
//        
//        let request = UNNotificationRequest(identifier: "daily_drink_notification", content: content, trigger: trigger)
//        UNUserNotificationCenter.current().add(request) { error in
//            if let error = error {
//                print("Error scheduling notification: \(error)")
//            }
//        }
//    }
    
    func scheduleDailyNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Drink Suggestion"
        content.body = "Check out a random drink recipe!"
        content.sound = .default
        
        // Set the time to 4:52 AM
        let triggerDate = DateComponents(hour: 4, minute: 52)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        
        let request = UNNotificationRequest(identifier: "daily_drink_notification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    func triggerImmediateNotification() {
        if isOnline() {
            fetchDrinkFromAPI { drink in
                self.sendNotification(for: drink)
            }
        } else {
            fetchDrinkFromCoreData { drink in
                self.sendNotification(for: drink)
            }
        }
    }
    
    private func isOnline() -> Bool {
        // Implement network reachability check
        // Example using NWPathMonitor from Network framework
        let monitor = NWPathMonitor()
        let semaphore = DispatchSemaphore(value: 0)
        var online = false

        monitor.pathUpdateHandler = { path in
            online = path.status == .satisfied
            semaphore.signal()
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
        
        _ = semaphore.wait(timeout: .now() + 5) // Wait for the network status update
        
        return online
    }

    
    private func fetchDrinkFromAPI(completion: @escaping (Drink) -> Void) {
        NetworkManager.shared.fetchDrinks(searchTerm: "") { result in
            switch result {
            case .success(let drinks):
                if !drinks.isEmpty {
                    // Select a random drink from the list
                    let randomDrink = drinks.randomElement()!
                    completion(randomDrink)
                } else {
                    print("No drinks found in API response")
                }
            case .failure(let error):
                print("Error fetching drinks from API: \(error)")
            }
        }
    }
    
    private func fetchDrinkFromCoreData(completion: @escaping (Drink) -> Void) {
        let favorites = FavoritesManager.shared.fetchFavorites()
        if let randomDrink = favorites.randomElement() {
            completion(randomDrink)
        } else {
            print("No drinks found in Core Data")
            
        }
    }
    
    private func sendNotification(for drink: Drink) {
        let content = UNMutableNotificationContent()
        content.title = "Drink Suggestion"
        content.body = "\(drink.strDrink)"
        content.sound = .default
        
        if let url = URL(string: drink.strDrinkThumb) {
            // Load image data from URL or use placeholder if URL is unavailable
            let data: Data
            if isOnline(), let imageData = try? Data(contentsOf: url) {
                data = imageData
            } else {
                // Use a local placeholder image or a default image for offline mode
                data = UIImage(named: "placeholder_image")?.jpegData(compressionQuality: 1.0) ?? Data()
            }
            
            if let attachment = UNNotificationAttachment.create(imageData: data, withIdentifier: drink.idDrink) {
                content.attachments = [attachment]
            }
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: "immediate_drink_notification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling immediate notification: \(error)")
            }
        }
    }
}

extension UNNotificationAttachment {
    static func create(imageData: Data, withIdentifier identifier: String) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let tempDirectory = fileManager.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent("\(identifier).jpg")
        do {
            try imageData.write(to: fileURL)
            let attachment = try UNNotificationAttachment(identifier: identifier, url: fileURL, options: nil)
            return attachment
        } catch {
            print("Error creating notification attachment: \(error)")
            return nil
        }
    }
}

// Helper extension to create a Drink object from JSON response
extension Drink {
    init(from dictionary: [String: Any]) {
        self.idDrink = dictionary["idDrink"] as? String ?? ""
        self.strDrink = dictionary["strDrink"] as? String ?? ""
        self.strDrinkThumb = dictionary["strDrinkThumb"] as? String ?? ""
        self.strAlcoholic = dictionary["strAlcoholic"] as? String ?? ""
        self.strInstructions = dictionary["strInstructions"] as? String ?? ""
        self.isFavorite = false // Or any default value
    }
}
