//
//  MasterViewController.swift
//  pH Simple NotePad
//
//  Created by Pierre-Henry Soria on 01/08/2016.
//  Copyright © 2016 Pierre-Henry Soria. All rights reserved.
//

import UIKit

// Set these vars/consts global because they will be used in other classes
var objects:[String] = [String]();
var currentIndex:Int = 0
var masterView:MasterViewController?
var detailViewController:DetailViewController?

let keyNotes:String = "note"
let BLANK_NOTE:String = "(A New Note)"


class MasterViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        masterView = self
        loadNotes()
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        saveNotes()
        super.viewWillAppear(animated)
    }
    
    // Overwrite viewDidAppear()
    override func viewDidAppear(animated: Bool) {
        if objects.count == 0 {
            insertNewObject(self)
        }
        // and call the inherited viewDidAppear() from the super class
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        if objects.count == 0 ||  objects[0] != BLANK_NOTE {
            objects.insert(BLANK_NOTE, atIndex: 0) // Default index = 0 (top one)
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
        currentIndex = 0 // Set the index to the default, top one
        self.performSegueWithIdentifier("showDetail", sender: self)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                currentIndex = indexPath.row
                detailViewController?.detailItem = object
                detailViewController?.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                detailViewController?.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let object = objects[indexPath.row]
        cell.textLabel!.text = object
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            return
        }
        saveNotes()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        saveNotes()
    }

    
    func saveNotes() {
        NSUserDefaults.standardUserDefaults().setObject(objects, forKey: keyNotes)
        NSUserDefaults.standardUserDefaults().synchronize() // Optional but very useful to automaticly save the note (without pressing the Home button)
    }
    
    func loadNotes() {
        if let loadNotes = NSUserDefaults.standardUserDefaults().arrayForKey(keyNotes) as? [String] {
            // If there are notes to load
            objects = loadNotes
        }
    }
}

