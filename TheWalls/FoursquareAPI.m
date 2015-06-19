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

+ (void)retrieveFoursquareResults:(NSURL *)url completion:(void(^)(NSArray *array))complete {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *jsonError = nil;
        NSMutableArray *storedObjects;
        NSDictionary *parsedResults = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        NSDictionary *parsedResults2 = [parsedResults valueForKey:@"response"];
        NSArray *results = [parsedResults2 valueForKey:@"venues"];
        for (NSDictionary *result in results) {
            FoursquareAPI *item = [[FoursquareAPI alloc]initWithJSONAndParse:result];
            [storedObjects addObject:item];
        }
        NSArray *array = [NSArray arrayWithArray:storedObjects];
        complete(array);
    }];
}


@end
