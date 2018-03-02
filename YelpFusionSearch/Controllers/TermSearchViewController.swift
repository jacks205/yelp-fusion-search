//
//  TermSearchViewController.swift
//  YelpFusionSearch
//
//  Created by Mark Jackson on 2/28/18.
//  Copyright © 2018 Mark Jackson. All rights reserved.
//

import UIKit

class TermSearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let viewModel = TermSearchViewModel()
    
    var pastSearchTerms: [String] {
        return Array<String>(viewModel.pastSearchTerms)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
                
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(TermSearchViewController.searchButtonClick))
        
        viewModel.requestLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func searchButtonClick() {
        guard let searchText = searchBar.text, searchText.count > 0 else {
            return
        }
        viewModel.add(searchTerm: searchText)
        searchBusinesses(withTerm: searchText)
    }
    
    func searchBusinesses(withTerm searchText: String) {
        performSegue(withIdentifier: "businessSearchResultsSegue", sender: searchText)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if  segue.identifier == "businessSearchResultsSegue",
            let searchText = sender as? String,
            let dvc = segue.destination as? BusinessSearchViewController {
            dvc.searchTerm = searchText
        }
    }

}

extension TermSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Past Searches"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pastSearchTerms.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchText = pastSearchTerms[indexPath.row]
        searchBusinesses(withTerm: searchText)
    }
}

extension TermSearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TermSearchCell", for: indexPath)
        let searchTerm = pastSearchTerms[indexPath.row]
        cell.textLabel?.text = searchTerm
        return cell
    }
}
