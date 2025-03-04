//
//  HomeViewController.swift
//  AttendenceScanner
//
//  Created by Tushar on 15/01/25.
//


import UIKit
import Toastify
import AlamofireImage
import DropSwiftKit

class EventsViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var btnStartDate: UIButton!
    @IBOutlet weak var btnEndDate: UIButton!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var btnClearWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnClearHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet weak var cvDetails: UICollectionView!
    
    var eventList: [Event] = []
    var filteredEventList: [Event] = []
    let eventService = EventListService()
    let logoutService = LogoutService()
    
    var selectedStartDate: Date?
    var selectedEndDate: Date?
    var searchKey: String?
    var currentPage = 1
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    func configUI() {
        cvDetails.delegate = self
        cvDetails.dataSource = self
        searchBar.delegate = self
        
        // Assign corner radius to buttons
        btnStartDate.layer.cornerRadius = 8
        btnEndDate.layer.cornerRadius = 8
        btnStartDate.clipsToBounds = true
        btnEndDate.clipsToBounds = true
        
        self.navigationItem.hidesBackButton = true
        self.fetchEventData(reset: true)
        
        // Define layout parameters
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 15 // Fixed spacing between items
        let itemsPerRow: CGFloat = 2
        let sideSpacing: CGFloat = 10
        
        // Get available width for collectionView
        let totalWidth = UIScreen.main.bounds.width // Instead of cvDetails.bounds.width
        let totalSpacing = (itemsPerRow - 1) * spacing + (2 * sideSpacing)
        
        // Calculate item width dynamically to maintain spacing
        let itemWidth = floor((totalWidth - totalSpacing) / itemsPerRow)
        let itemHeight: CGFloat = 250
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 10, left: sideSpacing, bottom: 10, right: sideSpacing)
        
        cvDetails.collectionViewLayout = layout
    }
    
    
    func fetchEventData(reset: Bool = false) {
        if isLoading { return }
        isLoading = true
        
        if reset {
            currentPage = 1
            eventList.removeAll()
            filteredEventList.removeAll()
            cvDetails.reloadData()
        }
        
        Indicator.show()
        
        let fromDate = selectedStartDate?.formattedDate()
        let toDate = selectedEndDate?.formattedDate()
        
        // ✅ Pass filtering parameters to API request
        eventService.fetchEventList(fromDate: fromDate, toDate: toDate, searchKey: searchKey, page: currentPage) { result in
            DispatchQueue.main.async {
                Indicator.hide()
                self.isLoading = false
                
                switch result {
                case .success(let eventData):
                    if eventData.status == "success" {
                        let newEvents = eventData.data?.values.map { $0 } ?? []
                        
                        if reset {
                            self.eventList = newEvents
                        } else {
                            self.eventList.append(contentsOf: newEvents)
                        }
                        
                        self.filteredEventList = self.eventList 
                        self.cvDetails.reloadData()
                        self.currentPage += 1
                    } else {
                        if let error = eventData.errorData {
                                Logger.log("❌ API Error: \(error.message ?? "Unknown error")")
                                
                                // ✅ Handle invalid user token error
                                if let userTokenError = error.data?.params?["user_token"]?.lowercased(),
                                   userTokenError.contains("invalid parameter") {
                                    Logger.log("🚨 User token invalid, redirecting to login...")
                                    if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                                        sceneDelegate.resetToLoginScreen()
                                    }
                                } else {
                                    Toast.show(message: error.message ?? "Unknown error occurred")
                                }
                            } else {
                                Logger.log("⚠️ API returned unknown error format")
                                Toast.show(message: eventData.message ?? "Unknown error occurred")
                            }
                    }
                case .failure(let error):
                    Toast.show(message: error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func didTapMenu(_ sender: UIBarButtonItem) {
        guard let sourceView = sender.value(forKey: "view") as? UIView else { return } // Extract UIView from UIBarButtonItem
        
        let actions = [
            DropdownAction(title: "Logout") {
                Logger.log("Logout")
                self.userLogout()
            }
        ]
        
        DropdownLauncher.show(from: sourceView, actions: actions, style: .sheet)
    }
    
    func userLogout() {
        Indicator.show()
        logoutService.userLogout(userId: String(UserDefaultsManager.shared.getUserId() ?? 0), userToken: UserDefaultsManager.shared.getUserToken() ?? "") { result in
            DispatchQueue.main.async {
                Indicator.hide()

                    if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                        sceneDelegate.resetToLoginScreen()
                    }
            }
        }
    }
    
    @IBAction func btnStartDateTapped(_ sender: UIButton) {
        showCustomDatePicker(on: self, title: "Select Start Date", initialDate: selectedStartDate) { date in
            if let endDate = self.selectedEndDate, date > endDate {
                Toast.show(message: "Start Date cannot be greater than End Date")
                return
            }
            
            self.selectedStartDate = date
            self.updateDateButtonTitle(self.btnStartDate, date: date)
            
        }
    }
    
    @IBAction func btnEndDateTapped(_ sender: UIButton) {
        showCustomDatePicker(on: self, title: "Select End Date", initialDate: selectedEndDate) { date in
            if let startDate = self.selectedStartDate, date < startDate {
                Toast.show(message: "End Date must be greater than or equal to Start Date")
                return
            }
            
            self.selectedEndDate = date
            self.updateDateButtonTitle(self.btnEndDate, date: date)
            
            // ✅ Now that both dates are selected, fetch filtered data
            if self.selectedStartDate != nil {
                self.fetchEventData(reset: true)
            }
            
            // ✅ Show Clear button only when End Date is selected
            self.btnClear.isHidden = false
            self.btnClearHorizontalConstraint.constant = 10
            self.btnClearWidthConstraint.constant = 40
        }
    }
    
    @IBAction func btnClearTapped(_ sender: UIButton) {
        selectedStartDate = nil
        selectedEndDate = nil
        searchKey = nil
        
        btnStartDate.setTitle("Start Date", for: .normal)
        btnEndDate.setTitle("End Date", for: .normal)
        searchBar.text = ""
    
        fetchEventData(reset: true)
        btnClear.isHidden = true
        btnClearHorizontalConstraint.constant = 0
        btnClearWidthConstraint.constant = 0
    }
    
}

// MARK: - SearchBar Delegate & DataSource
extension EventsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchKey = searchText.isEmpty ? nil : searchText
        
        if searchText.isEmpty {
            DispatchQueue.main.async { [weak self] in
                searchBar.resignFirstResponder() // ✅ Ensures keyboard dismissal
                self?.fetchEventData(reset: true) // ✅ Trigger API when cleared
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // ✅ Ensures keyboard dismissal
        searchKey = searchBar.text
        fetchEventData(reset: true) // ✅ Trigger API filtering
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension EventsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredEventList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cvDetails.dequeueReusableCell(withReuseIdentifier: "EventDetailsCollectionViewCell", for: indexPath) as! EventDetailsCollectionViewCell
        
        let event = filteredEventList[indexPath.row]
        
        cell.lblStartDate.text = "\(event.metaData?.startDate ?? "") \(event.metaData?.startTime ?? "")"
        cell.lblTitle.text = event.title
        
        if let imageUrl = event.image, let url = URL(string: imageUrl) {
            if imageUrl.hasSuffix(".svg") {
                cell.imgBG.setSVG(from: imageUrl)
            } else {
                cell.imgBG.af.setImage(withURL: url)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if filteredEventList.isEmpty { return }
        
        let selectedEvent = filteredEventList[indexPath.row]
        let eventDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "EventDetailViewController") as! EventDetailViewController
        eventDetailVC.eventID = selectedEvent.id ?? ""
        self.navigationController?.pushViewController(eventDetailVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight - 100 {
            fetchEventData()
        }
    }
}

// MARK: - UI update and filtering
extension EventsViewController {
    func updateDateButtonTitle(_ button: UIButton, date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        button.setTitle(formatter.string(from: date), for: .normal)
    }
    
}
