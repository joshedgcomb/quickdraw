//
//  Database.m
//  QuickDraw
//
//  Created by John Verticchio on 2/25/14.
//  Copyright (c) 2014 jverticchio. All rights reserved.
//

#import "Database.h"

@implementation Database

static sqlite3 *db;

static sqlite3_stmt *createDrawings;
static sqlite3_stmt *fetchDrawings;
static sqlite3_stmt *insertDrawing;
static sqlite3_stmt *deleteDrawing;

+ (void)createEditableCopyOfDatabaseIfNeeded {
    BOOL success;
    
    // look for an existing contacts database
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentDirectory stringByAppendingPathComponent:@"Database.sql"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return;
    
    // if failed to find one, copy the empty contacts database into the location
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Database.sql"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"FAILED to create writable database file with message, '%@'.", [error localizedDescription]);
    }
}

+ (void)initDatabase {
    // create the statement strings
    const char *createDrawingsString = "CREATE TABLE IF NOT EXISTS drawings (rowid INTEGER PRIMARY KEY AUTOINCREMENT, image BLOB)";
    const char *fetchDrawingsString = "SELECT * FROM drawings";
    const char *insertDrawingString = "INSERT INTO drawings (image) VALUES (?)";
    const char *deleteDrawingString = "DELETE FROM drawings WHERE rowid=?";
    
    // create the path to the database
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *path = [documentDirectory stringByAppendingPathComponent:@"Database.sql"];
    
    // open the database connection
    if (sqlite3_open([path UTF8String], &db)) {
        NSLog(@"ERROR opening the db");
    }
    
    
    
    int success;
    
    //init table statement
    if (sqlite3_prepare_v2(db, createDrawingsString, -1, &createDrawings, NULL) != SQLITE_OK) {
        NSLog(@"Failed to prepare drawings create table statement");
    }
    
    // execute the table creation statement
    success = sqlite3_step(createDrawings);
    sqlite3_reset(createDrawings);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to create drawing table");
    }
    
    //init retrieval statement
    if (sqlite3_prepare_v2(db, fetchDrawingsString, -1, &fetchDrawings, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare drawing fetching statement");
    }
    
    //init insertion statement
    if (sqlite3_prepare_v2(db, insertDrawingString, -1, &insertDrawing, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare drawing inserting statement");
    }
    
    // init deletion statement
    if (sqlite3_prepare_v2(db, deleteDrawingString, -1, &deleteDrawing, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare drawing deleting statement");
    }
    
}


+ (NSMutableArray *)fetchAllDrawings
{
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:0];
    
    
    
    while (sqlite3_step(fetchDrawings) == SQLITE_ROW) {
        
        NSData *imgData = [[NSData alloc] initWithBytes:sqlite3_column_blob(fetchDrawings, 1) length:sqlite3_column_bytes(fetchDrawings, 1)];
        
        //create Contact object, notice the query for the row id
        Drawing *temp = [[Drawing alloc] initWithImage:[UIImage imageWithData:imgData] andID:sqlite3_column_int(fetchDrawings, 0)];
        [ret addObject:temp];
        
    }
    
    sqlite3_reset(fetchDrawings);
    return ret;
}


+ (void)saveDrawingWithImage:(NSData *) imgData{
    // bind data to the statement
    sqlite3_bind_blob(insertDrawing, 1, [imgData bytes], [imgData length], SQLITE_TRANSIENT);
    
    int success = sqlite3_step(insertDrawing);
    sqlite3_reset(insertDrawing);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to insert drawing");
    }
}

+ (void)deleteDrawing:(int)rowid
{
    // bind the row id, step the statement, reset the statement, check for error... EASY
    sqlite3_bind_int(deleteDrawing, 1, rowid);
    int success = sqlite3_step(deleteDrawing);
    sqlite3_reset(deleteDrawing);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to delete drawing");
    }
}

+ (void)cleanUpDatabaseForQuit
{
    // finalize frees the compiled statements, close closes the database connection
    sqlite3_finalize(fetchDrawings);
    sqlite3_finalize(insertDrawing);
    sqlite3_finalize(deleteDrawing);
    sqlite3_finalize(createDrawings);
    sqlite3_close(db);
}


@end
