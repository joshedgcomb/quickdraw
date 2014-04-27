//
//  Drawing.m
//  QuickDraw
//
//  Created by jarthurcs on 2/27/14.
//  Copyright (c) 2014 jverticchio. All rights reserved.
//

#import "Drawing.h"

@implementation Drawing

-(id)initWithImage:(UIImage *)nImage andID: (int) id
{
    self.image = nImage;
    self.rowid = id;
    
    return self;
}

@end
