//
//  State.swift
//  CovidTracker
//
//  Created by Le Hoang Long on 06/03/2024.
//

import Foundation

struct StateModel: Codable {
    let meta: StateMeta? // (I)
    let data: [StateData]? // (II)
}

// (I)
struct StateMeta: Codable {
    let build_time: String?
    let license: String?
    let version: String?
    let field_definitions: [StateMetaFieldDefinitions]?
}

// MARK: meta.field_definitions
struct StateMetaFieldDefinitions: Codable {
    let name: String?
    let field: String?
    let deprecated: Bool?
    let prior_names: [String]?
}

// (II)
struct StateData: Codable {
    let name: String? // (1)
    let state_code: String? // (2)
    let fips: String? // (3)
    let sites: [StateDataSites]? // (4)
    let census: StateDataCensus? // (5)
    let field_sources: StateDataFieldSources? // (6)
    let covid_tracking_project: StateDataCovidTrackingProject? // (7)
}

// MARK: data.sites (4)
/*
 label: primary, secondary, tertiary (third), quaternary (fourth), quinary (fifth)
 */
struct StateDataSites: Codable {
    let url: String?
    let label: String?
}

// MARK: data.census (5)
struct StateDataCensus: Codable {
    let population: Int? // 2019 year
}

// MARK: data.field_sources (6)
struct StateDataFieldSources: Codable {
    let tests: StateDataFieldSourcesTest?
}

// MARK: data.field_sources.test
struct StateDataFieldSourcesTest: Codable {
    let pcr: StateDataFieldSourceTestPCR?
}

// MARK: data.field_sources.test.pcr
struct StateDataFieldSourceTestPCR: Codable {
    let total: String?
}

// MARK: data.covid_tracking_project (7)
struct StateDataCovidTrackingProject: Codable {
    let preferred_total_test: StateDataCovidTrackingProjectPreferredTotalTest?
}

// MARK: data.covid_tracking_project.preferred_total_test
/*
 field: totalTestEncountersViral, totalTestsViral, totalTestsPeopleViral, or—where those units are all missing a sufficient time series—totalTestResults.
 unit: test encounters, specimens, people, or—where those units are all missing a sufficent time series—negatives plus positives.
 */
struct StateDataCovidTrackingProjectPreferredTotalTest: Codable {
    let field: String? // COVID Tracking Project preferred total test field
    let units: String? // COVID Tracking Project preferred total test units
}
