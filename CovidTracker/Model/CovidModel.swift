//
//  CovidModel.swift
//  CovidTracker
//
//  Created by Le Hoang Long on 06/03/2024.
//

import Foundation

struct CovidModel: Codable {
    let meta: CovidMeta? // (I)
    let data: [CovidData]? // (II)
}

// (I)
struct CovidMeta: Codable {
    let build_time: String?
    let license: String?
    let version: String?
}

// (II)
struct CovidData: Codable {
    let date: String? // (1)
    let state: String? // (2)
    let meta: CovidDataMeta? // (3)
    let cases: CovidDataCases? // (4)
    let tests: CovidDataTests? // (5)
    let outcomes: CovidDataOutcomes? // (6)
}

// MARK: data.meta (3)
struct CovidDataMeta: Codable {
    let data_quality_grade: String?
    let updated: String?
    let tests: CovidDataMetaTest?
}

// MARK: data.meta.tests
struct CovidDataMetaTest: Codable {
    let total_source: String?
}

// MARK: data.cases (4)
struct CovidDataCases: Codable {
    let total: Int?
    let confirmed: Int?
    let probable: Int?
}

// MARK: data.tests (5)
struct CovidDataTests: Codable {
    let pcr: CovidDataTestPCR?
    let antibody: CovidTestAntibody?
    let antigen: CovidTestAntigen?
}

// MARK: data.tests.pcr
struct CovidDataTestPCR: Codable {
    let total: Int?
    let pending: Int?
    let encounters: CovidDataTestPCREncounters?
    let specimens: CovidDataTestPCRSpecimens?
    let people: CovidDataTestPCRPeople?
}

// MARK: data.test.pcr.encounters
struct CovidDataTestPCREncounters: Codable {
    let total: Int?
}

// MARK: data.tests.pcr.specimens
struct CovidDataTestPCRSpecimens: Codable {
    let total: Int?
    let positive: Int?
    let negative: Int?
}

// MARK: data.tests.pcr.people
struct CovidDataTestPCRPeople: Codable {
    let total: Int?
    let positive: Int?
    let negative: Int?
}

// MARK: data.tests.antibody
struct CovidTestAntibody: Codable {
    let encounters: CovidTestAntibodyEncounters?
    let people: CovidTestAntibodyPeople?
}

// MARK: data.tests.antibody.encounters
struct CovidTestAntibodyEncounters: Codable {
    let total: Int?
    let positive: Int?
    let negative: Int?
}

// MARK: data.tests.antibody.people
struct CovidTestAntibodyPeople: Codable {
    let total: Int?
    let positive: Int?
    let negative: Int?
}

// MARK: data.tests.antigen
struct CovidTestAntigen: Codable {
    let encounters: CovidTestAntigenEncounters?
    let people: CovidTestAntigenPeople?
}

// MARK: data.tests.antigen.encounters
struct CovidTestAntigenEncounters: Codable {
    let total: Int?
    let positive: Int?
    let negative: Int?
}

// MARK: data.tests.antigen.people
struct CovidTestAntigenPeople: Codable {
    let total: Int?
    let positive: Int?
    let negative: Int?
}

// MARK: data.outcomes (6)
struct CovidDataOutcomes: Codable {
    let recovered: Int?
    let hospitalized: CovidTestAntibody?
    let death: CovidTestAntigen?
}

// MARK: data.outcomes.hospitalized
struct CovidDataOutcomesHospitalized: Codable {
    let total: Int?
    let currently: Int?
    let in_icu: CovidDataOutcomesHospitalizedInICU?
    let on_ventilator: CovidDataOutcomesHospitalizedOnVentilator?
}

// MARK: data.outcomes.hospitalized.in_icu
struct CovidDataOutcomesHospitalizedInICU: Codable {
    let total: Int?
    let currently: Int?
}

// MARK: data.outcomes.hospitalized.on_ventilator
struct CovidDataOutcomesHospitalizedOnVentilator: Codable {
    let total: Int?
    let currently: Int?
}

// MARK: data.outcomes.death
struct CovidDataOutcomesDeath: Codable {
    let total: Int?
    let confirmed: Int?
    let probable: Int?
}
