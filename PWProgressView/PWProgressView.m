//
//  TestView.m
//  PWProgressView
//
//  Created by Peter Willsey on 12/17/13.
//  Copyright (c) 2013 Peter Willsey, Inc. All rights reserved.
//

#import "PWProgressView.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat PWCenterHoleInsetRatio             = 0.2f;
static const CGFloat PWProgressShapeInsetRatio          = 0.03f;
static const CGFloat PWDefaultAlpha                     = 0.45f;
static const CGFloat PWScaleAnimationScaleFactor        = 2.3f;
static const CFTimeInterval PWScaleAnimationDuration    = 0.5;

@interface PWProgressView ()

@property (nonatomic, strong) CAShapeLayer *boxShape;
@property (nonatomic, strong) CAShapeLayer *progressShape;

@end

@implementation PWProgressView

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.alpha = PWDefaultAlpha;
        
        self.boxShape = [CAShapeLayer layer];
        
        self.boxShape.fillColor         = [UIColor blackColor].CGColor;
        self.boxShape.anchorPoint       = CGPointMake(0.5f, 0.5f);
        self.boxShape.contentsGravity   = kCAGravityCenter;
        self.boxShape.fillRule          = kCAFillRuleEvenOdd;

        self.progressShape = [CAShapeLayer layer];
        
        self.progressShape.fillColor   = [UIColor clearColor].CGColor;
        self.progressShape.strokeColor = [UIColor blackColor].CGColor;

        [self.layer addSublayer:self.boxShape];
        [self.layer addSublayer:self.progressShape];
    }
    
    return self;
}

- (void)layoutSubviews
{
    CGFloat centerHoleInset     = PWCenterHoleInsetRatio * CGRectGetWidth(self.bounds);
    CGFloat progressShapeInset  = PWProgressShapeInsetRatio * CGRectGetWidth(self.bounds);
    
    CGSize pathSize=CGSizeZero;
    if (CGRectGetWidth(self.bounds)>CGRectGetHeight(self.bounds)) {
        pathSize.height=CGRectGetHeight(self.bounds);
        pathSize.width=CGRectGetHeight(self.bounds);
    }else{
        pathSize.height=CGRectGetWidth(self.bounds);
        pathSize.width=CGRectGetWidth(self.bounds);
    }
    
    CGRect pathRect = CGRectMake(CGPointZero.x,
                                 CGPointZero.y,
                                 CGRectGetWidth(self.bounds),
                                 CGRectGetHeight(self.bounds));
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:pathRect];
    
    CGRect holePathRect=CGRectZero;
    holePathRect.size=CGSizeMake(pathSize.width - centerHoleInset * 2, pathSize.height - centerHoleInset * 2);
    holePathRect.origin=CGPointMake((CGRectGetWidth(pathRect)-CGRectGetWidth(holePathRect))/2, (CGRectGetHeight(pathRect)-CGRectGetHeight(holePathRect))/2);
    [path appendPath:[UIBezierPath bezierPathWithRoundedRect:holePathRect
                                                cornerRadius:(pathSize.width - centerHoleInset * 2) / 2.0f]];
    
    [path setUsesEvenOddFillRule:YES];
    
    self.boxShape.path = path.CGPath;
    self.boxShape.bounds = pathRect;
    self.boxShape.position = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMidY(pathRect));
    
    CGFloat diameter = pathSize.width - (2 * centerHoleInset) - (2 * progressShapeInset);
    CGFloat radius = diameter / 2.0f;
    
    self.progressShape.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(CGRectGetMidX(holePathRect) - (radius / 2.0f),
                                                                                 CGRectGetMidY(holePathRect) - (radius / 2.0f),
                                                                                 radius,
                                                                                 radius)
                                                         cornerRadius:radius].CGPath;
    
    self.progressShape.lineWidth = radius;
}

- (void)setProgress:(float)progress
{
    if ([self pinnedProgress:progress] != _progress) {
        self.progressShape.strokeStart = progress;
        
        if (_progress == 1.0f && progress < 1.0f) {
            [self.boxShape removeAllAnimations];
        }
        
        _progress = [self pinnedProgress:progress];
        
        if (_progress == 1.0f) {
            CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            scaleAnimation.toValue = @(PWScaleAnimationScaleFactor);
            scaleAnimation.duration = PWScaleAnimationDuration;
            scaleAnimation.removedOnCompletion = NO;
            scaleAnimation.autoreverses = NO;
            scaleAnimation.fillMode = kCAFillModeForwards;
            [self.boxShape addAnimation:scaleAnimation forKey:@"transform.scale"];
        }
    }
}

- (float)pinnedProgress:(float)progress
{
    float pinnedProgress = MAX(0.0f, progress);
    pinnedProgress = MIN(1.0f, pinnedProgress);
    
    return pinnedProgress;
}

@end
