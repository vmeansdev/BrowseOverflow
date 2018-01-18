//
//  Answer.h
//  BrowseOverflow
//
//  Created by vmeansdev on 18/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

@interface Answer : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic) Person *person;
@property (nonatomic) NSInteger score;
@property (nonatomic, getter=isAccepted) BOOL accepted;


- (NSComparisonResult)compare:(Answer *)otherAnswer;

@end
