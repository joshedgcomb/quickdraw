//
//  Database.h
//  QuickDraw
//
//  Created by John Verticchio on 2/25/14.
//  Copyright (c) 2014 jverticchio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Score.h"

@interface Database : NSObject

+ (void)createEditableCopyOfDatabaseIfNeeded;
+ (void)initDatabase;
+ (NSMutableArray *)fetchAllScores;
+ (void)saveScoreWithName:(NSString *)name andScore:(NSString *)score;
+ (void)deleteScore:(int)rowid;
+ (void)cleanUpDatabaseForQuit;

@end
