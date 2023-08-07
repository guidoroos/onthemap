//
//  UserDataResponse.swift
//  OnTheMap
//
//  Created by Guido Roos on 01/08/2023.
//

import Foundation

struct UserDataResponse: Codable {
    var user: User? = User()
}

struct User: Codable {
    var lastName: String?
    var socialAccounts: [String]?
    var mailingAddress: String?
    var cohortKeys: [String]?
    var signature: String?
    var stripeCustomerId: String?
    var settings: Settings?
    var facebookId: String?
    var timezone: String?
    var sitePreferences: String?
    var occupation: String?
    var image: String?
    var firstName: String?
    var jabberId: String?
    var languages: String?
    var badges: [String]?
    var location: String?
    var externalServicePassword: String?
    var principals: [String]?
    var enrollments: [String]?
    var email: Email?
    var websiteUrl: String?
    var externalAccounts: [String]?
    var bio: String?
    var coachingData: String?
    var tags: [String]?
    var affiliateProfiles: [String]?
    var hasPassword: Bool?
    var emailPreferences: EmailPreferences?
    var resume: String?
    var key: String?
    var nickname: String?
    var employerSharing: Bool?
    var memberships: [Memberships]?
    var zendeskId: String?
    var registered: Bool?
    var linkedinUrl: String?
    var googleId: String?
    var imageUrl: String?

    enum CodingKeys: String, CodingKey {
        case lastName
        case socialAccounts
        case mailingAddress
        case cohortKeys = "CohortKeys"
        case signature = "Signature"
        case stripeCustomerId = "StripeCustomerId"
        case settings = "guard"
        case facebookId = "FacebookId"
        case timezone
        case sitePreferences
        case occupation
        case image = "Image"
        case firstName
        case jabberId
        case languages
        case badges = "Badges"
        case location
        case externalServicePassword
        case principals = "Principals"
        case enrollments = "Enrollments"
        case email
        case websiteUrl
        case externalAccounts
        case bio
        case coachingData
        case tags
        case affiliateProfiles = "AffiliateProfiles"
        case hasPassword = "HasPassword"
        case emailPreferences
        case resume = "Resume"
        case key
        case nickname
        case employerSharing
        case memberships = "Memberships"
        case zendeskId = "zendesk_id"
        case registered = "Registered"
        case linkedinUrl = "linkedin_url"
        case googleId = "GoogleId"
        case imageUrl = "ImageUrl"
    }
}

struct Memberships: Codable {
    var current: Bool? = nil
    var groupRef: Ref? = Ref()
    var creationTime: String? = nil
    var expirationTime: String? = nil
}

struct EmailPreferences: Codable {
    var okUserResearch: Bool? = nil
    var masterOk: Bool? = nil
    var okCourse: Bool? = nil
}

struct Email: Codable {
    var VerificationCodeSent: Bool? = nil
    var Verified: Bool? = nil
    var address: String? = nil
}

struct Settings: Codable {
    var canEdit: Bool? = nil
    var permissions: [Permissions]? = []
    var allowedBehaviors: [String]? = []
    var subjectKind: String? = nil
}

struct Permissions: Codable {
    var derivation: [String]? = []
    var behavior: String? = nil
    var principalRef: Ref? = Ref()
}

struct Ref: Codable {
    var ref: String? = nil
    var key: String? = nil
}
