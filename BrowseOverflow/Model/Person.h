//
//  Person.h
//  BrowseOverflow
//
//  Created by vmeansdev on 17/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (readonly) NSString *name;
@property (readonly) NSURL *avatarURL;

- (instancetype)initWithName:(NSString *)aName avatarLocation:(NSString *)location;

@end
