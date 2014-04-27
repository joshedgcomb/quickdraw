//
//  Score.m
//  QuickDraw
//
//  Created by John Verticchio on 2/25/14.
//  Copyright (c) 2014 jverticchio. All rights reserved.
//

#import "Score.h"

@implementation Score

-(id)initWithName:(NSString *)nName andScore:(NSString *)nScore andID: (int) id
{
    self.name = nName;
    self.score = nScore;
    self.rowid = id;
    
    return self;
}

@end
