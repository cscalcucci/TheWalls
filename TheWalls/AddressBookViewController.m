//
//  AddressBookViewController.m
//  TheWalls
//
//  Created by Bryon Finke on 6/17/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import "AddressBookViewController.h"
#import "Contact.h"

@interface AddressBookViewController () <UITableViewDataSource, UITableViewDelegate>
@property PFUser *currentUser;
@property (weak, nonatomic) IBOutlet UINavigationBar *addressBookNav;
@property NSMutableArray *members;
@property NSMutableArray *nonmembers;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *matchNumbers;
@end

@implementation AddressBookViewController

- (IBAction)onLogoutPressed:(UIButton *)sender {
    [PFUser logOutInBackground];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Onboarding" bundle:[NSBundle mainBundle]];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    [self presentViewController:viewController animated:NO completion:NULL];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.members = [NSMutableArray new];
    self.addressBookNav.topItem.title = @"Add Contacts";
    [self requestAddressBookAccess];
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    [AddressBookViewController listPeopleInAddressBook:addressBook withCompletion:^(NSArray *contacts) {
        NSMutableArray *contactsNumbers = [NSMutableArray new];
        for (NSDictionary *contact in contacts) {
            for (NSString *number in [contact objectForKey:@"numbers"]) {
                [contactsNumbers addObject:number];
            }
        }
        PFQuery *userQuery = [PFUser query];
        [userQuery whereKey:@"phone" containedIn:contactsNumbers];
        NSLog(@"query results: %lu", userQuery.countObjects);
        [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                self.matchNumbers = [[NSArray alloc] init];
                self.matchNumbers = objects;
                NSLog(@"match numbers (inside): %lu", self.matchNumbers.count);
            } else {
                // Log details of the failure
                NSLog(@"error");
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
//        [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//            NSArray *matchUsers = [NSArray arrayWithArray:objects];
//            NSLog(@"match users: %lu", matchUsers.count);
//            for (PFUser *user in matchUsers) {
//                [matchNumbers addObject:[user objectForKey:@"phone"]];
//            }
//        }];
        NSLog(@"contacts numbers: %@", contactsNumbers);
        NSLog(@"match numbers: %lu", self.matchNumbers.count);
        NSLog(@"matches: %lu", contactsNumbers.count);
        for (NSString *match in contactsNumbers) {
            for (NSDictionary *contact in contacts) {
                BOOL member = false;
                NSLog(@"contact: %@", [contact objectForKey:@"name"]);
                NSLog(@"pre-loop: %s", member ? "true" : "false");
                for (NSString *number in [contact objectForKey:@"numbers"]) {
                    if ([match isEqualToString:number]) {
                        member = true;
                    }
                }
                NSLog(@"post-loop: %s", member ? "true" : "false");
                if (member == true) {
                    [self.members addObject:contact];
                } else {
                    [self.nonmembers addObject:contact];
                }
            }
        }
        NSLog(@"members: %lu", self.members.count);
        NSLog(@"nonmember: %lu", self.nonmembers.count);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.members.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    PFUser *user = [self.members objectAtIndex:indexPath.row];
    cell.textLabel.text = [user objectForKey:@"phone"];

    return cell;
}

- (void)requestAddressBookAccess {
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
        ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted){
        NSLog(@"Denied");
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        NSLog(@"Authorized");
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined){
        NSLog(@"Not determined");
        ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
            if (!granted){
                NSLog(@"Just denied");
                return;
            }
            NSLog(@"Just authorized");
        });
    }
}

+ (void)listPeopleInAddressBook:(ABAddressBookRef)addressBook withCompletion:(void (^)(NSArray *numbers))completionHandler {
    NSMutableArray *contactsArray = [NSMutableArray new];

    NSArray *allPeople = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
    NSInteger numberOfPeople = [allPeople count];

    for (NSInteger i = 0; i < numberOfPeople; i++) {
        NSMutableArray *numbersArray = [NSMutableArray new];
        NSString *name = [NSString new];
        ABRecordRef person = (__bridge ABRecordRef)allPeople[i];

        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
        name = (__bridge NSString *)ABRecordCopyCompositeName(person);

        CFIndex numberOfPhoneNumbers = ABMultiValueGetCount(phoneNumbers);

        for (CFIndex i = 0; i < numberOfPhoneNumbers; i++) {
            NSString *phoneNumber = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneNumbers, i));
            NSString *trimmedNumber = [[phoneNumber componentsSeparatedByCharactersInSet:
                                        [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                       componentsJoinedByString:@""];
            if ([trimmedNumber hasPrefix:@"1"] && [trimmedNumber length] > 1) {
                trimmedNumber = [trimmedNumber substringFromIndex:1];
            }
            NSLog(@"%@", trimmedNumber);
            [numbersArray addObject:trimmedNumber];
        }
        NSDictionary *contact = [[NSDictionary alloc] initWithObjectsAndKeys:
                               name ?: [NSNull null], @"name",
                               numbersArray ?: [NSNull null], @"numbers",
                               nil];
        [contactsArray addObject:contact];
        CFRelease(phoneNumbers);
    }
    completionHandler(contactsArray);
}

- (void)findProfilesFromNumbers:(NSArray *)numbers withCompletion:(void (^)(NSArray *profiles))completionHandler {
    // Using PFQuery
    PFQuery *userQuery = [PFQuery queryWithClassName:@"PFUser"];
    [userQuery includeKey:@"phone"];

    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        NSMutableArray *matches = [NSMutableArray new];
        NSLog(@"%@",objects.firstObject);
        for (PFUser *profile in objects) {
            if ([numbers containsObject:profile.username]) {
                [matches addObject:profile];
            }
        }
        completionHandler(matches);
    }];
}

@end
