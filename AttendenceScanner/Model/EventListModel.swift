//
//  EventListModel.swift
//  AttendenceScanner
//
//  Created by Tushar on 16/01/25.
//

import Foundation

struct EventListModel: Codable {
    let status: String?
    let message: String?
    let pagination: Pagination?
    let data: [String: Event]?
    let errorData: APIListError?

    enum CodingKeys: String, CodingKey {
        case status, message, pagination, data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        message = try container.decodeIfPresent(String.self, forKey: .message)
        pagination = try container.decodeIfPresent(Pagination.self, forKey: .pagination)

       
        if let eventData = try? container.decode([String: Event].self, forKey: .data) {
            data = eventData
            errorData = nil
        } else {
            data = nil
            errorData = try? APIListError(from: decoder)
        }
    }
}

// MARK: - Pagination
struct Pagination: Codable {
    let currentPage: Int?
    let totalPage: Int?
    let postsCount: Int?
    let limit: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case totalPage = "total_page"
        case postsCount = "posts_count"
        case limit
    }
}

// MARK: - Event
struct Event: Codable {
    let id: String?
    let title: String?
    let excerpt: String?
    let image: String?
    let metaData: EventListData?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case title, excerpt, image
        case metaData = "meta_data"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Convert ID to String safely
        if let idInt = try? container.decode(Int.self, forKey: .id) {
            id = String(idInt)
        } else {
            id = try container.decodeIfPresent(String.self, forKey: .id)
        }

        title = try container.decodeIfPresent(String.self, forKey: .title)
        excerpt = try container.decodeIfPresent(String.self, forKey: .excerpt)
        image = try container.decodeIfPresent(String.self, forKey: .image)
        
        metaData = try? container.decode(EventListData.self, forKey: .metaData)
    }
}

// MARK: - EventListData
struct EventListData: Codable {
    let startDate: String?
    let startTime: String?
    let endDate: String?
    let endTime: String?
    let ticketPrice: String?
    let registrationType: String?
    let registrationClosing: String?
    let website: String?
    let address: String?
    let disclaimer: String?
    let facebookURL: String?
    let instagramURL: String?
    let linkedinURL: String?
    let twitterURL: String?
    let mediaURLs: [String]?
    let totalSlots: String?
    let usedSlots: String?

    enum CodingKeys: String, CodingKey {
        case startDate = "psyem_event_startdate"
        case startTime = "psyem_event_starttime"
        case endDate = "psyem_event_enddate"
        case endTime = "psyem_event_endtime"
        case ticketPrice = "psyem_event_ticket_price"
        case registrationType = "psyem_event_registration_type"
        case registrationClosing = "psyem_event_registration_closing"
        case website = "psyem_event_website"
        case address = "psyem_event_address"
        case disclaimer = "psyem_event_disclaimer"
        case facebookURL = "psyem_event_facebook_url"
        case instagramURL = "psyem_event_instagram_url"
        case linkedinURL = "psyem_event_linkedin_url"
        case twitterURL = "psyem_event_twitter_url"
        case mediaURLs = "psyem_event_media_urls"
        case totalSlots = "psyem_event_total_slots"
        case usedSlots = "psyem_event_used_slots"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        startDate = try container.decodeIfPresent(String.self, forKey: .startDate)
        startTime = try container.decodeIfPresent(String.self, forKey: .startTime)
        endDate = try container.decodeIfPresent(String.self, forKey: .endDate)
        endTime = try container.decodeIfPresent(String.self, forKey: .endTime)
        ticketPrice = try container.decodeIfPresent(String.self, forKey: .ticketPrice)
        registrationType = try container.decodeIfPresent(String.self, forKey: .registrationType)
        registrationClosing = try container.decodeIfPresent(String.self, forKey: .registrationClosing)
        website = try container.decodeIfPresent(String.self, forKey: .website)
        address = try container.decodeIfPresent(String.self, forKey: .address)
        disclaimer = try container.decodeIfPresent(String.self, forKey: .disclaimer)
        facebookURL = try container.decodeIfPresent(String.self, forKey: .facebookURL)
        instagramURL = try container.decodeIfPresent(String.self, forKey: .instagramURL)
        linkedinURL = try container.decodeIfPresent(String.self, forKey: .linkedinURL)
        twitterURL = try container.decodeIfPresent(String.self, forKey: .twitterURL)
        totalSlots = try container.decodeIfPresent(String.self, forKey: .totalSlots)
        usedSlots = try container.decodeIfPresent(String.self, forKey: .usedSlots)

        // Handle both array and string cases for `mediaURLs`
        if let mediaArray = try? container.decode([String].self, forKey: .mediaURLs) {
            mediaURLs = mediaArray
        } else if let singleMedia = try? container.decode(String.self, forKey: .mediaURLs) {
            mediaURLs = [singleMedia]
        } else {
            mediaURLs = nil
        }
    }
}

// MARK: - APIError Model
struct APIListError: Codable {
    let code: String?
    let message: String?
    let data: ErrorListData?

    enum CodingKeys: String, CodingKey {
        case code, message, data
    }
}

struct ErrorListData: Codable {
    let status: Int?
    let params: [String: String]?
}

class EventListService {
    
    func fetchEventList(fromDate: String? = nil, toDate: String? = nil, searchKey: String? = nil, signupType: String? = nil, page: Int = 1, completion: @escaping (Result<EventListModel, Error>) -> Void) {
        
        let parameters: [String: Any] = [
            "from_date": fromDate ?? "",
            "to_date": toDate ?? "",
            "search_key": searchKey ?? "",
            "signup_type": signupType ?? "",
            "paged": page,
            "user_token": UserDefaultsManager.shared.getUserToken() ?? ""
        ]
        
        NetworkService.shared.get(url: APIConstants.eventList, parameters: parameters, completion: completion)
    }
}
