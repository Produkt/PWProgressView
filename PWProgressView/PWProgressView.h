//
//  TestView.h
//  PWProgressView
//
//  Created by Peter Willsey on 12/17/13.
//  Copyright (c) 2013 Peter Willsey, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWProgressView : UIView
@property (nonatomic, assign) CGFloat centerHoleInsetRatio;
@property (nonatomic, assign) CGFloat progressShapeInsetRatio;
@property (nonatomic, assign) CGFloat progressAlpha;
@property (nonatomic, assign) CGFloat scaleAnimationScaleFactor;
@property (nonatomic, assign) CFTimeInterval scaleAnimationDuration;
@property (nonatomic, assign) CGFloat progress;
@end
