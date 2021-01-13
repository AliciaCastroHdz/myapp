//
//  RecipeMenuViewController.swift
//  myapp
//
//  Created by Alicia Monserrath Castro Hernandez on 13/01/21.
//

import UIKit

class RecipeMenuViewController: UIViewController, IRecipesPresenter {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var presenter: RecipesPresenter?
    var recipes: [RecipeModel] = []

    private var currentPage = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = RecipesPresenter(view: self)
        self.search(by: "")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = 180
        self.tableView.estimatedRowHeight = 180
        let cellName = "RecipeTableViewCell"
        self.tableView.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
        self.setupSearhBar()
    }

    func setupSearhBar() {
        self.searchBar.delegate = self
     }

    func showErrorAlert(title: String, msg: String?) { }
    
    func showResponse(response: [RecipeModel]) {
        print("response: ", response.count)
        self.recipes.removeAll(keepingCapacity: false)
        self.recipes.append(contentsOf: response)
        self.tableView.reloadData()
    }
}

extension RecipeMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath)
        let cell: RecipeTableViewCell
        if let optionCell = reusableCell as? RecipeTableViewCell {
            cell = optionCell
        } else {
            cell = RecipeTableViewCell()
        }
        cell.setRecipe(self.recipes[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = self.recipes[indexPath.row]
        let vc = RecipeDetailsViewController(nibName: "RecipeDetailsViewController", bundle: nil)
        vc.recipe = recipe
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension RecipeMenuViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchBar - textDidChange: ", searchText)
        self.search(by: searchText)
    }

    fileprivate func search(by text: String) {
        self.presenter?.getRecipes(query: text)
    }
}
