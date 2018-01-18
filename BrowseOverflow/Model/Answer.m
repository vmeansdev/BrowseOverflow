//
//  Answer.m
//  BrowseOverflow
//
//  Created by vmeansdev on 18/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import "Answer.h"

@implementation Answer

- (NSComparisonResult)compare:(Answer *)otherAnswer{
    if (self.accepted && !(otherAnswer.accepted)){
        return NSOrderedAscending;
    } else if (!self.accepted && otherAnswer.accepted){
        return NSOrderedDescending;
    }
    
    if (self.score > otherAnswer.score){
        return NSOrderedAscending;
    } else if (self.score < otherAnswer.score) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

- (BOOL)isAccepted{
    return _accepted;
}

@end
