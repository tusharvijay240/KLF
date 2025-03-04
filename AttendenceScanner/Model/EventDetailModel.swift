//
//  EventResponse.swift
//  AttendenceScanner
//
//  Created by Tushar on 05/02/25.
//


import Foundation

struct EventDetailModel: Codable {
    let status: String?
    let message: String?
    let data: EventData?
    let errorData: APIDetailError?

    enum CodingKeys: String, CodingKey {
        case status, message, data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        message = try container.decodeIfPresent(String.self, forKey: .message)

        if let eventData = try? container.decode(EventData.self, forKey: .data),
           eventData.id != nil {
            data = eventData
            errorData = nil
        }
        else {
            data = nil
            errorData = try? APIDetailError(from: decoder) 
        }
    }
}


struct EventData: Codable {
    let id: Int?
    let title: String?
    let excerpt: String?
    let image: String?
    let metaData: EventDetail?
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case title, excerpt, image
        case metaData = "meta_data"
    }
}

struct EventDetail: Codable {
    let eventStartDate: String?
    let eventStartTime: String?
    let eventEndDate: String?
    let eventEndTime: String?
    let eventTicketPrice: String?
    let eventRegistrationType: String?
    let eventRegistrationClosing: String?
    let eventWebsite: String?
    let eventAddress: String?
    let eventDisclaimer: String?
    let facebookURL: String?
    let instagramURL: String?
    let linkedinURL: String?
    let twitterURL: String?
    let mediaURLs: [String]?
    let totalSlots: String?
    let usedSlots: String?

    enum CodingKeys: String, CodingKey {
        case eventStartDate = "psyem_event_startdate"
        case eventStartTime = "psyem_event_starttime"
        case eventEndDate = "psyem_event_enddate"
        case eventEndTime = "psyem_event_endtime"
        case eventTicketPrice = "psyem_event_ticket_price"
        case eventRegistrationType = "psyem_event_registration_type"
        case eventRegistrationClosing = "psyem_event_registration_closing"
        case eventWebsite = "psyem_event_website"
        case eventAddress = "psyem_event_address"
        case eventDisclaimer = "psyem_event_disclaimer"
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

        eventStartDate = try container.decodeIfPresent(String.self, forKey: .eventStartDate)
        eventStartTime = try container.decodeIfPresent(String.self, forKey: .eventStartTime)
        eventEndDate = try container.decodeIfPresent(String.self, forKey: .eventEndDate)
        eventEndTime = try container.decodeIfPresent(String.self, forKey: .eventEndTime)
        eventTicketPrice = try container.decodeIfPresent(String.self, forKey: .eventTicketPrice)
        eventRegistrationType = try container.decodeIfPresent(String.self, forKey: .eventRegistrationType)
        eventRegistrationClosing = try container.decodeIfPresent(String.self, forKey: .eventRegistrationClosing)
        eventWebsite = try container.decodeIfPresent(String.self, forKey: .eventWebsite)
        eventAddress = try container.decodeIfPresent(String.self, forKey: .eventAddress)
        eventDisclaimer = try container.decodeIfPresent(String.self, forKey: .eventDisclaimer)
        facebookURL = try container.decodeIfPresent(String.self, forKey: .facebookURL)
        instagramURL = try container.decodeIfPresent(String.self, forKey: .instagramURL)
        linkedinURL = try container.decodeIfPresent(String.self, forKey: .linkedinURL)
        twitterURL = try container.decodeIfPresent(String.self, forKey: .twitterURL)
        totalSlots = try container.decodeIfPresent(String.self, forKey: .totalSlots)
        usedSlots = try container.decodeIfPresent(String.self, forKey: .usedSlots)

        // ✅ FIX: Handle `mediaURLs` being a String or an Array
        if let mediaArray = try? container.decode([String].self, forKey: .mediaURLs) {
            mediaURLs = mediaArray
        } else if let singleMedia = try? container.decode(String.self, forKey: .mediaURLs), !singleMedia.isEmpty {
            mediaURLs = [singleMedia]
        } else {
            mediaURLs = nil
        }
    }
}

// MARK: - Corrected API Error Model
struct APIDetailError: Codable {
    let code: String?
    let message: String?
    let data: ErrorDetailData?

    enum CodingKeys: String, CodingKey {
        case code, message, data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        code = try container.decodeIfPresent(String.self, forKey: .code)
        message = try container.decodeIfPresent(String.self, forKey: .message)
        data = try container.decodeIfPresent(ErrorDetailData.self, forKey: .data)
    }
}

// MARK: - Corrected Error Detail Data Model
struct ErrorDetailData: Codable {
    let status: Int?
    let params: [String: String]?

    enum CodingKeys: String, CodingKey {
        case status, params
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decodeIfPresent(Int.self, forKey: .status)
        params = try container.decodeIfPresent([String: String].self, forKey: .params)
    }
}


class EventDetailService {
    
    func fetchEventDetail(eventID: String, completion: @escaping (Result<EventDetailModel, Error>) -> Void) {
        
        let urlWithToken = APIConstants.eventDetail(eventID: eventID, userToken: UserDefaultsManager.shared.getUserToken() ?? "")
               NetworkService.shared.get(url: urlWithToken, completion: completion)
        NetworkService.shared.get(url: urlWithToken, completion: completion)
    }
    
}
