//
//  SubjectService.swift
//  Elite Instructor
//
//  Created by Jonathan Lu on 2/10/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation
import Alamofire

open class SubjectService : ISubjectService {
	
	public init(){
	}
	
	open func getMasterSubjects(_ liveOnly : Bool, completion: @escaping (_ success : Bool, _ subjects : [ApiSubject]?) -> Void ){
        
        Alamofire.request(Router.getMasterSubjects(liveOnly))
			.responseCollection { (response: DataResponse<[ApiSubject]>) in
                completion(true, response.result.value)
        }
    }
    
	open func getChildSubjects(_ masterSubjectId: String, liveOnly: Bool, completion: @escaping (_ success : Bool, _ subjects : [ApiSubject]?) -> Void){
        
        Alamofire.request(Router.getChildSubjects(masterSubjectId, liveOnly))
            .responseCollection { (response: DataResponse<[ApiSubject]>) in
                completion(true, response.result.value)
        }
    }
}
