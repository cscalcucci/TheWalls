//
//  SplatCollectionViewCell.h
//  TheWalls
//
//  Created by Bryon Finke on 6/22/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@interface SplatCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PFImageView *imageView;
@end
