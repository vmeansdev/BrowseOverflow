//
//  Person.m
//  BrowseOverflow
//
//  Created by vmeansdev on 17/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import "Person.h"
@interface Person()

@property (readwrite) NSString *name;
@property (readwrite) NSURL *avatarURL;

@end

@implementation Person

- (instancetype)initWithName:(NSString *)aName avatarLocation:(NSString *)location{
    if (self = [super init]){
        self.name = [aName copy];
        self.avatarURL = [NSURL URLWithString:location];
    }
    
    return self;
}

@end
