//
//  AddressBookViewController.m
//  TheWalls
//
//  Created by Bryon Finke on 6/17/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import "AddressBookViewController.h"

@interface AddressBookViewController ()
@property PFUser *currentUser;
@property (weak, nonatomic) IBOutlet UINavigationBar *addressBookNav;
@property NSMutableArray *members;
@property NSMutableArray *nonmembers;
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

    self.addressBookNav.topItem.title = @"Add Contacts";
    [self requestAddressBookAccess];
//    self listPeopleInAddressBook:<#(ABAddressBookRef)#> withCompletion:<#^(NSArray *numbers)completionHandler#>
//    ABPeoplePickerNavigationController *picker =
//    [[ABPeoplePickerNavigationController alloc] init];
//    picker.peoplePickerDelegate = self;
//
//    [self presentModalViewController:picker animated:YES];
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

- (void)listPeopleInAddressBook:(ABAddressBookRef)addressBook withCompletion:(void (^)(NSArray *numbers))completionHandler {
    NSMutableArray *numbersArray = [NSMutableArray new];

    NSArray *allPeople = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
    NSInteger numberOfPeople = [allPeople count];

    for (NSInteger i = 0; i < numberOfPeople; i++) {
        ABRecordRef person = (__bridge ABRecordRef)allPeople[i];

        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);

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
        CFRelease(phoneNumbers);
    }
    completionHandler(numbersArray);
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
