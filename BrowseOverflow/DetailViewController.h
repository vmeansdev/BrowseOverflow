//
//  DetailViewController.h
//  BrowseOverflow
//
//  Created by vmeansdev on 16/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSDate *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

