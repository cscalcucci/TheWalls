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
@property (weak, nonatomic) IBOutlet UIView *sectionOne;
@end

@implementation AddressBookViewController

- (IBAction)onLogoutPressed:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PrimaryView" bundle:[NSBundle mainBundle]];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
    [self presentViewController:viewController animated:NO completion:NULL];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.members = [NSMutableArray new];
    self.nonmembers = [NSMutableArray new];
    self.addressBookNav.topItem.title = @"Add Contacts";

    [self requestAddressBookAccess];

    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    [AddressBookViewController listPeopleInAddressBook:addressBook withCompletion:^(NSArray *contacts) {
        NSMutableArray *cNumbers = [NSMutableArray new];
        for (NSMutableDictionary *contact in contacts) {
            for (NSString *number in [contact objectForKey:@"numbers"]) {
                [cNumbers addObject:number];
            }
        }
        PFQuery *userQuery = [PFUser query];
        [userQuery whereKey:@"phone" containedIn:cNumbers];
        NSLog(@"total contacts: %lu", contacts.count);
        NSLog(@"query results: %lu", userQuery.countObjects);
        [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            NSArray *matches = [NSArray new];
            if (!error) {
                matches = objects;
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
            for (NSMutableDictionary *contact in contacts) {
                BOOL memberCheck = false;
                for (PFUser *match in matches) {
                    for (NSString *number in [contact objectForKey:@"numbers"]) {
                        if ([number isEqualToString:[match objectForKey:@"phone"]]) {
                            memberCheck = true;
                            [contact setObject:[match objectForKey:@"username"] forKey:@"username"];
                        }
                    }
                }
                if (memberCheck) {
                    [self.members addObject:contact];
                } else {
                    [self.nonmembers addObject:contact];
                }
            }
            NSLog(@"members: %lu", self.members.count);
            NSLog(@"nonmember: %lu", self.nonmembers.count);
            [self.tableView reloadData];
        }];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2 ;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"SplatChatters in Address Book";
    } else {
        return @"Invite to SplatChat";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return self.members.count;
    } else {
        return self.nonmembers.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];

    if (indexPath.section==0) {
        NSDictionary *user = [self.members objectAtIndex:indexPath.row];
        cell.textLabel.text = [user objectForKey:@"name"];
        cell.detailTextLabel.text = [user objectForKey:@"username"];
    }
    else {
        NSDictionary *user = [self.nonmembers objectAtIndex:indexPath.row];
        cell.textLabel.text = [user objectForKey:@"name"];
        NSMutableString *phoneNumber = [NSMutableString new];
        phoneNumber = [user objectForKey:@"numbers"][0];
        NSString *part1 = [phoneNumber substringWithRange:(NSMakeRange(0, 3))];
        NSString *part2 = [phoneNumber substringWithRange:(NSMakeRange(3, 3))];
        NSString *part3 = [phoneNumber substringWithRange:(NSMakeRange(6, 4))];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@-%@", part1, part2, part3];
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark) {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    } else {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    }
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
            [numbersArray addObject:trimmedNumber];
        }
        NSMutableDictionary *contact = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                               name ?: [NSNull null], @"name",
                               numbersArray ?: [NSNull null], @"numbers",
                               nil ?: [NSNull null], @"username",
                               nil];
        [contactsArray addObject:contact];
        CFRelease(phoneNumbers);
    }
    completionHandler(contactsArray);
}

@end
