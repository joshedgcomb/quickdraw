//
//  HighScore.m
//  QuickDraw
//
//  Created by jarthurcs on 3/2/14.
//  Copyright (c) 2014 jverticchio. All rights reserved.
//

#import "HighScore.h"
#import "PFObject.h"

@implementation HighScore

@synthesize name;
@synthesize score;

- (id) initWithName:(NSString *)newName andScore:(NSNumber *)newScore {
	self = [super init];
    if (self != nil) {
        self.name = newName;
		self.score = newScore;
    }
    return self;
}

+ (void) saveHighScore:(NSNumber *)score withName:(NSString *)name {
	PFObject *scoreObject = [[PFObject alloc] initWithClassName:@"HighScore"];
	[scoreObject setObject:score forKey:@"score"];
	[scoreObject setObject:name forKey:@"name"];
	[scoreObject save];
}

+ (NSArray *) getTopHighScores:(NSUInteger)numberOfScores {
	PFQuery *query = [[PFQuery alloc] initWithClassName:@"HighScore"];
	query.limit = [NSNumber numberWithUnsignedInt:numberOfScores];
	query.order = @"-score";
	
	NSArray *objects = [PFObject findObjects:query];
	NSMutableArray *highScoreObjects = [[NSMutableArray alloc] initWithCapacity:numberOfScores];
	
	NSUInteger i = 0;
	for(PFObject *object in objects) {
		HighScore *highScore = [[HighScore alloc] initWithName:[object objectForKey:@"name"] andScore:[object objectForKey:@"score"]];
		[highScoreObjects insertObject:highScore atIndex:i];
		i++;
	}
	
	return highScoreObjects;
}


@end
