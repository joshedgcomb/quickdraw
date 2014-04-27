//
//  ShapeView.h
//  QuickDraw
//
//  Created by jarthurcs on 4/14/14.
//  Copyright (c) 2014 jverticchio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum shapeTypes
{ triangleShape,
    rectangleShape,
    circleShape,
    tShape
} ShapeType;


@interface ShapeView : UIView{
ShapeType currentShapeType;

}

- (id)initWithFrame:(CGRect)frame shape:(int)shape;
@end
