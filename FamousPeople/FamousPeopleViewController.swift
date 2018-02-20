// Copyright (c) 2017 Lighthouse Labs. All rights reserved.
// 
// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
// distribute, sublicense, create a derivative work, and/or sell copies of the
// Software in any work that is designed, intended, or marketed for pedagogical or
// instructional purposes related to programming, coding, application development,
// or information technology.  Permission for such use, copying, modification,
// merger, publication, distribution, sublicensing, creation of derivative works,
// or sale is expressly withheld.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

class FamousPeopleViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  var data: [[String: String]]?
  var db = DatabaseManager()
  
  override func viewDidLoad() {
    db.openDatabase()
    data = db.getAllPeople()
    
    let dbFileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)

    print(dbFileURL)
    
    super.viewDidLoad()
  }
  
  func searchForPeople(withName name: String) {
    print("search for people with name: \(name)")
    data = db.getAllPeople(withNameLike: name)
    tableView.reloadData()
  }
}

extension FamousPeopleViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data!.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CustomTableViewCell  else {
      fatalError("The dequeued cell is not an instance of UITableViewCell.")
    }
    
    // Fetches the appropriate meal for the data source layout.
    let person = data![indexPath.row]
    //print(person)
    
    cell.firstNameLabel.text = person["first_name"]
    cell.firstNameLabel.sizeToFit()
    
    cell.lastNameLabel.text = person["last_name"]
    cell.lastNameLabel.sizeToFit()
 
    return cell
  }
}

extension FamousPeopleViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    guard let name = searchBar.text else {
      return
    }
    searchForPeople(withName: name)
  }
}
