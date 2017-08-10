//
//  Contractor.m
//  ValayAdmin
//
//  Created by Andre Creighton on 7/27/17.
//  Copyright © 2017 Andre Creighton. All rights reserved.
//

#import "VLYContractor.h"

@implementation VLYContractor


-(instancetype)initWithUserId:(NSString *)userId name:(NSString *)name streetAddress:(NSString *)streetAddress city:(NSString *)city state:(NSString *)state zipCode:(NSString *)zipCode photoUrl:(NSString *)photoUrl photoIdUrl:(NSString *)photoIdUrl email:(NSString *)email contact:(NSString *)number service:(NSString *)serviceName subServices:(NSString *)subServices{
    
    
    self = [super init];
    
    if (self) {
     
        _userId = userId;
        _name = name;
        _streetAddress = streetAddress;
        _city = city;
        _state = state;
        _zipCode = zipCode;
        _photoUrl = photoUrl;
        _email = email;
        _contact = number;
        _serviceName = serviceName;
        _subServices = subServices;
        _photoIdUrl = photoIdUrl;
        
    }
 
    
    return self;
}



@end
