//
//  Drawing.h
//  QuickDraw
//
//  Created by jarthurcs on 2/27/14.
//  Copyright (c) 2014 jverticchio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Drawing : NSObject

@property int rowid;
@property UIImage *image;

-(id)initWithImage:(UIImage *)nImage andID: (int) id;

@end
