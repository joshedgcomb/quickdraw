//
//  HighScore.h
//  QuickDraw
//
//  Created by jarthurcs on 3/2/14.
//  Copyright (c) 2014 jverticchio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFObject.h"

@interface HighScore : NSObject {
    NSNumber *score;
    NSString *name;
}

@property (nonatomic, retain) NSNumber *score;
@property (nonatomic, retain) NSString *name;

- (id) initWithName:(NSString *)nameObj andScore:(NSNumber *)scoreObj;
+ (void) saveHighScore:(NSNumber *)score withName:(NSString *)score;
+ (NSArray *) getTopHighScores:(NSUInteger)numberOfScores;

@end