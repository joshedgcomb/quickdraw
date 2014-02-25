//
//  Score.h
//  QuickDraw
//
//  Created by John Verticchio on 2/25/14.
//  Copyright (c) 2014 jverticchio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Score : NSObject

@property int rowid;
@property NSString *name;
@property NSString *score;

-(id)initWithName:(NSString *)nName andScore:(NSString *)nScore andID: (int) id;

@end
