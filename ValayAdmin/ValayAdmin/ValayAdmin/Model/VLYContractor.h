//
//  Contractor.h
//  ValayAdmin
//
//  Created by Andre Creighton on 7/27/17.
//  Copyright © 2017 Andre Creighton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLYContractor : NSObject


//Fields that will be extracting from Firebase of Contractor.

@property (strong, nonatomic) NSString  *userId;
@property (strong, nonatomic) NSString  *name;
@property (strong, nonatomic) NSString  *streetAddress;
@property (strong, nonatomic) NSString  *city;
@property (strong, nonatomic) NSString  *state;
@property (strong, nonatomic) NSString  *zipCode;
@property (strong, nonatomic) NSString  *photoUrl;
@property (strong, nonatomic) NSString  *photoIdUrl;
@property (strong, nonatomic) NSString  *email;
@property (strong, nonatomic) NSString  *contact;
@property (strong, nonatomic) NSString  *serviceName;
@property (strong, nonatomic) NSString  *subServices;





-(instancetype)initWithUserId:(NSString *)userId
                         name:(NSString *)name
                streetAddress:(NSString *)streetAddress
                         city:(NSString *)city
                        state:(NSString *)state
                      zipCode:(NSString *)zipCode
                     photoUrl:(NSString *)photoUrl
                   photoIdUrl:(NSString *)photoIdUrl
                        email:(NSString *)email
                      contact:(NSString *)contact
                      service:(NSString *)serviceName
                  subServices:(NSString *)subServices;




@end
