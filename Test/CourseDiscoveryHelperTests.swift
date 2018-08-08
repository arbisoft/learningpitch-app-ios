//
//  CourseDiscoveryHelperTests.swift
//  edXTests
//
//  Created by Salman on 06/08/2018.
//  Copyright © 2018 edX. All rights reserved.
//

import XCTest
@testable import edX

private let sampleInvalidProgramDetailURL = "//course_info?path_id=course/usmx-corporate-finance"
private let sampleEnrolledProgramDetailURL = "edxapp://enrolled_program_info?path_id=programs/a3951294-926b-4247-8c3c-51c1e4347a15/details_fragment"
private let sampleEnrolledCourseDetailURL = "edxapp://enrolled_course_info?course_id=course-v1:USMx+BUMM612+2T2018"
private let sampleProgramCourseURL = "edxapp://course_info?path_id=course/usmx-corporate-finance"
private let sampleCourseEnrollmentURL = "edxapp://enroll?course_id=course-v1:USMx+BUMM610+3T2018&email_opt_in=true"
private let sampleProgramURL = "https://courses.edx.org/dashboard/programs_fragment/?mobile_only=true"
private let sampleInvalidProgramURLTemplate = "https://courses.edx.org/dashboard/mobile_only=true"
private let sampleProgramURLTemplate = "https://courses.edx.org/dashboard/{path_id}?mobile_only=true"

private extension OEXConfig {
    
    convenience init(programURL: String = "", programDetailURLTemplate:String = "", programEnabled: Bool = false) {
        self.init(dictionary: [
            "PROGRAM" : [
                "PROGRAM_URL": programURL,
                "PROGRAM_DETAIL_URL_TEMPLATE": programDetailURLTemplate,
                "PROGRAM_ENABLED": programEnabled
                ]
            ]
        )
    }
}

class CourseDiscoveryHelperTests: XCTestCase {
    
    func testAppURL() {
        var url = CourseDiscoveryHelper.appURL(url: URL(string: sampleEnrolledProgramDetailURL)!)
        XCTAssertEqual(url, WebviewActions.enrolledProgramDetail)
        
        url = CourseDiscoveryHelper.appURL(url: URL(string: sampleEnrolledCourseDetailURL)!)
        XCTAssertEqual(url, WebviewActions.enrolledCourseDetail)
        
        url = CourseDiscoveryHelper.appURL(url: URL(string: sampleProgramCourseURL)!)
        XCTAssertEqual(url, WebviewActions.courseDetail)
        
        url = CourseDiscoveryHelper.appURL(url: URL(string: sampleCourseEnrollmentURL)!)
        XCTAssertEqual(url, WebviewActions.courseEnrollment)
    }
    
    func testInvalidAppURL() {
        let url = CourseDiscoveryHelper.appURL(url: URL(string: sampleInvalidProgramDetailURL)!)
        XCTAssertNil(url)
    }
    
    func testDetailPathID() {
        let pathID = CourseDiscoveryHelper.detailPathID(from: URL(string: sampleProgramCourseURL)!)
        XCTAssertEqual(pathID, "usmx-corporate-finance")
    }
    
    func testInvalidDetailPathID() {
        var url = CourseDiscoveryHelper.detailPathID(from: URL(string: sampleInvalidProgramDetailURL)!)
        XCTAssertNil(url)
        
         url = CourseDiscoveryHelper.detailPathID(from: URL(string: sampleEnrolledProgramDetailURL)!)
        XCTAssertNil(url)
    }
    
    func testParseURL() {
        let urlData = CourseDiscoveryHelper.parse(url: URL(string: sampleCourseEnrollmentURL)!)
        XCTAssertEqual(urlData?.courseId, "course-v1:USMx+BUMM610+3T2018")
        XCTAssertTrue((urlData?.emailOptIn)!)        
    }
    
    func testParseURLFail() {
        let urlData = CourseDiscoveryHelper.parse(url: URL(string: sampleInvalidProgramDetailURL)!)
        XCTAssertNil(urlData)
    }
    
    func testProgramURL(){
        var config = OEXConfig(programURL: sampleProgramURL, programDetailURLTemplate: sampleProgramURLTemplate, programEnabled: true)

        var url = CourseDiscoveryHelper.programDetailURL(from: URL(string: sampleEnrolledProgramDetailURL)!, config: config)
        XCTAssertEqual(url?.absoluteString, "https://courses.edx.org/dashboard/programs/a3951294-926b-4247-8c3c-51c1e4347a15/details_fragment?mobile_only=true")

        url = CourseDiscoveryHelper.programDetailURL(from: URL(string: sampleInvalidProgramURLTemplate)!, config: config)
        XCTAssertNil(url)
        
        config = OEXConfig(programURL:sampleProgramURLTemplate, programEnabled: true)
        url = CourseDiscoveryHelper.programDetailURL(from: URL(string: sampleEnrolledProgramDetailURL)!, config: config)
        XCTAssertNil(url)
    }
}
