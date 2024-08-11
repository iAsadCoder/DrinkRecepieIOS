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

    // Reference to the view controller to present alerts
    weak var viewController: UIViewController?

    
    // half an hour time perios set it to 1 to 5 to get immediate notification
    func scheduleMealNotification() {

        if isOnline() {
            fetchDrinkFromAPI { drink in
                self.sendNotification(for: drink, timeInterval: 30 * 60)
            }
        } else {
            fetchDrinkFromCoreData { drink in
                self.sendNotification(for: drink, timeInterval: 30 * 60)
            }
        }
        
        
        // Show an immediate alert to the user
        DispatchQueue.main.async {
            self.showMealStartedAlert()
        }
    }



    private func isOnline() -> Bool {
        // Implement network reachability check
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
        NetworkManager.shared.fetchDrinks(searchTerm: "margarita", searchType: .byName) { result in
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
                //knwdkjd
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

    private func sendNotification(for drink: Drink, timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "Drink Suggestion"
        content.body = "\(drink.strDrink)"
        content.sound = .default
        
        // Add image to the notification
        if let url = URL(string: drink.strDrinkThumb) {
            if isOnline() {
                SDWebImageManager.shared.loadImage(with: url, options: [], progress: nil) { image, data, error, cacheType, finished, url in
                    if let image = image, let imageData = image.jpegData(compressionQuality: 1.0) {
                        if let attachment = UNNotificationAttachment.create(imageData: imageData, withIdentifier: drink.idDrink) {
                            content.attachments = [attachment]
                        }
                    } else {
                        print("Error loading image: \(String(describing: error))")
                    }
                    
                    // Schedule notification with the specified time interval
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
                    let request = UNNotificationRequest(identifier: "immediate_drink_notification", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request) { error in
                        if let error = error {
                            print("Error scheduling immediate notification: \(error)")
                        }
                    }
                }
            } else {
                let placeholderData = UIImage(named: "placeholder_image")?.jpegData(compressionQuality: 1.0) ?? Data()
                if let attachment = UNNotificationAttachment.create(imageData: placeholderData, withIdentifier: drink.idDrink) {
                    content.attachments = [attachment]
                }
                
                // Schedule notification with the specified time interval
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
                let request = UNNotificationRequest(identifier: "immediate_drink_notification", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error scheduling immediate notification: \(error)")
                    }
                }
            }
        } else {
            // Schedule notification with the specified time interval
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            let request = UNNotificationRequest(identifier: "immediate_drink_notification", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling immediate notification: \(error)")
                }
            }
        }
    }

    


    private func showMealStartedAlert() {
        guard let viewController = viewController else { return }
        
        let alert = UIAlertController(title: "Meal Started", message: "You have started your meal. Enjoy!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        viewController.present(alert, animated: true, completion: nil)
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
