//
//  Database.h
//  QuickDraw
//
//  Created by John Verticchio on 2/25/14.
//  Copyright (c) 2014 jverticchio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Drawing.h"

@interface Database : NSObject

+ (void)createEditableCopyOfDatabaseIfNeeded;
+ (void)initDatabase;

+ (NSMutableArray *)fetchAllDrawings;
+ (void)saveDrawingWithImage:(NSData *) imgData;
+ (void)deleteDrawing:(int)rowid;

+ (void)cleanUpDatabaseForQuit;

@end
