//
//  FoursquareAPI.h
//  TheWalls
//
//  Created by John McClelland on 6/17/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoursquareAPI : NSObject

@property (copy, nonatomic) NSString *venueID;
@property (copy, nonatomic) NSString *venueName;
@property (copy, nonatomic) NSString *category;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *state;
@property (copy, nonatomic) NSString *zipcode;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;

- (instancetype)initWithJSONAndParse:(NSDictionary *)jSONDictionary;
+ (void)retrieveFoursquareResults:(NSURL *)url completion:(void(^)(NSArray *array))complete;

@end