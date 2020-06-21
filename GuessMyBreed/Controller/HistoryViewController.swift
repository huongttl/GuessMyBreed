//
//  HistoryViewController.swift
//  GuessMyBreed
//
//  Created by Huong Tran on 6/2/20.
//  Copyright © 2020 RiRiStudio. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UITableViewController {

    var breeds: [String]! {
        let object = UIApplication.shared.delegate
        let delegate = object as! AppDelegate
        return delegate.breeds
    }
    
    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<Dog>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBar = self.tabBarController as! TabBarViewController
        dataController = tabBar.dataController
        overrideUserInterfaceStyle = .light
        setUpFetchedResultsController()
    }
    
    func deleteHistory(at index: IndexPath) {
        let dogToDelete = fetchedResultsController.object(at: index)
        dataController.viewContext.delete(dogToDelete)
        try? dataController.viewContext.save()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections?[0].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyReuseIdentifier", for: indexPath) as! HistoryTableViewCell

        let dogToShow = fetchedResultsController.object(at: indexPath)
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd hh:mm:ss"
        if let playedDate = dogToShow.date {
            let date = dateFormater.string(from: playedDate)
            cell.dateLabel.text = date
        }
        if let image = dogToShow.image {
            cell.dogImageView.image = UIImage(data: image)
        }
        
        cell.breedLabel.text = dogToShow.breed?.localizedCapitalized
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            deleteHistory(at: indexPath)
        default:
            () //Unsupported
        }
    }

    func setUpFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Dog> = Dog.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
}

extension HistoryViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            break
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        default:
            () // Unsupported
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
