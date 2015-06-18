//
//  FoursquareAPI.m
//  TheWalls
//
//  Created by John McClelland on 6/17/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import "FoursquareAPI.h"

@implementation FoursquareAPI {
    NSDictionary *json;
}

-(instancetype)initWithJSONAndParse:(NSDictionary *)jSONDictionary{
    self = [super init];
    if (self) {
        json = jSONDictionary;
    }
    return self;
}
/*
@property (copy, nonatomic) NSString *state;
@property (copy, nonatomic) NSString *zipcode;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
*/

-(NSString *)venueID {
    return json[@"id"];
}

-(NSString *)venueName {
    return json[@"name"];
}

-(NSString *)category {
    NSArray *categories = json[@"categories"];
    NSDictionary *name = categories[0];
    return [name objectForKey:@"name"];
}

-(NSString *)city {
    NSDictionary *location = json[@"location"];
    return [location objectForKey:@"city"];
}

-(NSString *)state {
    NSDictionary *location = json[@"location"];
    return [location objectForKey:@"state"];
}

-(NSString *)zipcode {
    NSDictionary *location = json[@"location"];
    return [location objectForKey:@"postalCode"];
}

-(float)latitude {
    NSDictionary *lat = json[@"location"];
    NSString *latitude = [lat objectForKey:@"lat"];
    return latitude.floatValue;
}

-(float)longitude {
    NSDictionary *lat = json[@"location"];
    NSString *longitude = [lat objectForKey:@"lng"];
    return longitude.floatValue;
}

@end
