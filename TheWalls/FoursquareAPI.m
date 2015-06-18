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
@property (copy, nonatomic) NSString *category;
@property (copy, nonatomic) NSString *city;
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

//-(NSString *)category {
//    NSDictionary *categories = json[@"categories"];
//    return [categories objectForKey:@"name"];
//}

-(NSString *)userProfilePictureURL {
    NSDictionary *user = json[@"user"];
    return [user objectForKey:@"profile_picture"];
}

-(NSString *)imageThumbNailURL; {
    NSDictionary *images = json[@"images"];
    NSDictionary *thumbnail = [images objectForKey:@"thumbnail"];
    return [thumbnail objectForKey:@"url"];
}

-(NSString *)imageLowResolutionURL; {
    NSDictionary *images = json[@"images"];
    NSDictionary *lowRes = [images objectForKey:@"low_resolution"];
    return [lowRes objectForKey:@"url"];
}

-(NSString *)imageStandardResolutionURL; {
    NSDictionary *images = json[@"images"];
    NSDictionary *stdRes = [images objectForKey:@"standard_resolution"];
    return [stdRes objectForKey:@"url"];
}


@end
