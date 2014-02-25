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

static sqlite3_stmt *createScores;
static sqlite3_stmt *fetchScores;
static sqlite3_stmt *insertScore;
static sqlite3_stmt *deleteScore;

+ (void)createEditableCopyOfDatabaseIfNeeded {
    BOOL success;
    
    // look for an existing contacts database
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentDirectory stringByAppendingPathComponent:@"highScores.sql"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return;
    
    // if failed to find one, copy the empty contacts database into the location
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"highScores.sql"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"FAILED to create writable database file with message, '%@'.", [error localizedDescription]);
    }
}

+ (void)initDatabase {
    // create the statement strings
    const char *createScoresString = "CREATE TABLE IF NOT EXISTS scores (rowid INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, score TEXT)";
    const char *fetchScoresString = "SELECT * FROM scores";
    const char *insertScoreString = "INSERT INTO scores (name, score) VALUES (?, ?)";
    const char *deleteScoreString = "DELETE FROM scores WHERE rowid=?";
    
    // create the path to the database
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *path = [documentDirectory stringByAppendingPathComponent:@"myFavorites.sql"];
    
    // open the database connection
    if (sqlite3_open([path UTF8String], &db)) {
        NSLog(@"ERROR opening the db");
    }
    
    
    
    int success;
    
    //init table statement
    if (sqlite3_prepare_v2(db, createScoresString, -1, &createScores, NULL) != SQLITE_OK) {
        NSLog(@"Failed to prepare favorites create table statement");
    }
    
    // execute the table creation statement
    success = sqlite3_step(createScores);
    sqlite3_reset(createScores);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to create favorites table");
    }
    
    //init retrieval statement
    if (sqlite3_prepare_v2(db, fetchScoresString, -1, &fetchScores, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare favorite fetching statement");
    }
    
    //init insertion statement
    if (sqlite3_prepare_v2(db, insertScoreString, -1, &insertScore, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare favorite inserting statement");
    }
    
    // init deletion statement
    if (sqlite3_prepare_v2(db, deleteScoreString, -1, &deleteScore, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare favorite deleting statement");
    }
    
    
}

+ (NSMutableArray *)fetchAllFavorites
{
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:0];
    
    
    
    while (sqlite3_step(fetchScores) == SQLITE_ROW) {
        
        // query columns from fetch statement
        char *nameChars = (char *) sqlite3_column_text(fetchScores, 1);
        char *scoreChars = (char *) sqlite3_column_text(fetchScores, 2);
        
        
        // convert to NSStrings
        NSString *tempName = [NSString stringWithUTF8String:nameChars];
        NSString *tempScore = [NSString stringWithUTF8String:scoreChars];
        
        
        //create Contact object, notice the query for the row id
        Score *temp = [[Score alloc] initWithName:tempName andScore:tempScore andID:sqlite3_column_int(fetchScores, 0)];
        
        [ret addObject:temp];
        
    }
    
    sqlite3_reset(fetchScores);
    return ret;
}

+ (void)saveFavoriteWithName:(NSString *)name andLocation:(NSString *)score andMeal:(NSString *)meal
{
    // bind data to the statement
    sqlite3_bind_text(insertScore, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertScore, 2, [score UTF8String], -1, SQLITE_TRANSIENT);

    
    
    int success = sqlite3_step(insertScore);
    sqlite3_reset(insertScore);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to insert favorite");
    }
    NSLog(@"saved score %@", score);
}

+ (void)deleteFavorite:(int)rowid
{
    // bind the row id, step the statement, reset the statement, check for error... EASY
    sqlite3_bind_int(deleteScore, 1, rowid);
    int success = sqlite3_step(deleteScore);
    sqlite3_reset(deleteScore);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to delete favorite");
    }
}

+ (void)cleanUpDatabaseForQuit
{
    // finalize frees the compiled statements, close closes the database connection
    sqlite3_finalize(fetchScores);
    sqlite3_finalize(insertScore);
    sqlite3_finalize(deleteScore);
    sqlite3_finalize(createScores);
    sqlite3_close(db);
}


@end
