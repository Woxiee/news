//
//  MenuModel.m
//  CaiDan
//
//  Created by  on 12-8-27.
//  Copyright (c) 2012年 JianQiao. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "OldMenuModel.h"
@interface OldMenuModel (){

    CGPoint center;
}
-(void)wobble:(CGFloat)angle;
-(void)stopWobble;
-(void)iconClicked;
-(void)deltClicked;
@end

#define HEIGHT_RATIO 0.75
#define DELBTN_HEIGHT_RATIO 0.2

#define ANGLE M_PI*1.5/180.0

@implementation OldMenuModel

@synthesize delegate;
@synthesize isActive;
@synthesize selects;
@synthesize seriel=_serial;
@synthesize mark;

-(void)setBadge:(NSInteger)_badge{
    if (_badge>0) {
        if (_badge>99) {
//            _badge = 99;
            badgeLab.text=[NSString stringWithFormat:@"%d+",_badge];
        } else {
            badgeLab.text=[NSString stringWithFormat:@"%d",_badge];
        }
        badgeImg.image=[UIImage imageNamed:@"notebg.png"];
        
        //badgeLab.text=[NSString stringWithFormat:@"%@",@"!"];
    }else{
        badgeImg.image=nil;
        badgeLab.text=nil;
    }
}
-(NSInteger)badge{
    return [badgeLab.text intValue];
}

-(void)setIsActive:(BOOL)_isActive{
    isActive=_isActive;
    
    if (isActive) {
        deltBtn.hidden=NO;
        iconBtn.enabled=NO;
        [self wobble:ANGLE];
    }else{
        deltBtn.hidden=YES;
        iconBtn.enabled=YES;
        [self stopWobble];
    }
}
-(BOOL)isActive{
    return isActive;
}
-(void)setTitle:(NSString *)theTitle{
    
    titleLab.text=theTitle;

}
-(NSString *)title{
    return titleLab.text;
}
-(void)setIcon:(NSString *)iconName{
    [iconBtn setBackgroundImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
}
-(NSString *)icon{
    return nil;
}

-(void)wobble:(CGFloat)angle{
    CABasicAnimation* wob=[CABasicAnimation animationWithKeyPath:@"transform"];
    wob.duration=0.2;
    wob.autoreverses=YES;
    wob.removedOnCompletion=NO;
    wob.repeatCount=MAXFLOAT;
    wob.fromValue=[NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, angle, 0, 0, 1.0)];
    wob.toValue=[NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, -angle, 0, 0, 1.0)];
    [self.layer addAnimation:wob forKey:@"wobAnimation"];
}
-(void)stopWobble{
    [self.layer removeAnimationForKey:@"wobAnimation"]; 
}


-(void)deltClicked{
    
    if ([delegate respondsToSelector:@selector(deleteMenuForIndex:title:)]) {
        
        BOOL shouldDel=[delegate deleteMenuForIndex:self.seriel title:self.title];
        if (shouldDel) [self animateRemoveSelf];
    }
}
-(void)iconClicked{
    BOOL oldMethod=NO;
    if ([delegate respondsToSelector:@selector(selectMenuForIndex:title:)]) {
        oldMethod=[delegate selectMenuForIndex:self.seriel title:self.title];
    }
    if (!oldMethod && [delegate respondsToSelector:@selector(selectMenuForIndex:mark:title:)]) {
        [delegate selectMenuForIndex:self.seriel mark:self.mark title:self.title];
    }
    
}
-(void)configMember{
    
    iconBtn=[[UIButton alloc]init];
    [iconBtn addTarget:self action:@selector(iconClicked) forControlEvents:UIControlEventTouchUpInside];
    iconBtn.enabled=YES;
    [self addSubview:iconBtn];
    
    
    deltBtn=[[UIButton alloc]init];
    [deltBtn setBackgroundImage:[UIImage imageNamed:@"deleteperson"] forState:UIControlStateNormal];
    [deltBtn addTarget:self action:@selector(deltClicked) forControlEvents:UIControlEventTouchUpInside];
    deltBtn.hidden=NO;
    [self addSubview:deltBtn];

    
    titleLab=[[UILabel alloc]init];
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.backgroundColor=[UIColor clearColor];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.font = [UIFont fontWithName:@"Arial" size:13];
//    [titleLab setFont:[UIFont systemFontOfSize:15.0]];
    [self addSubview:titleLab];
    
    badgeImg=[[UIImageView alloc]init];
    badgeImg.backgroundColor=[UIColor clearColor];
    [self addSubview:badgeImg];
    
    badgeLab=[[UILabel alloc]init];
    badgeLab.textAlignment=NSTextAlignmentCenter;
    badgeLab.font=[UIFont fontWithName:@"Arial" size:15];
    badgeLab.textColor=[UIColor whiteColor];
    badgeLab.backgroundColor=[UIColor clearColor];
    [self addSubview:badgeLab];
    
    bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgButton addTarget:self action:@selector(deltClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bgButton];
  
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configMember];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        [self configMember];

    }
    return self;
}
-(void)layoutSubviews{
    CGFloat h=self.frame.size.height;
    CGFloat w=self.frame.size.width;

    [iconBtn setFrame:CGRectMake(0, 10, w, h*HEIGHT_RATIO-5)];
    
    [deltBtn setFrame:CGRectMake(w-15, -2, h*DELBTN_HEIGHT_RATIO+10, h*DELBTN_HEIGHT_RATIO+10)];
   // [titleLab setFrame:CGRectMake(0, h*HEIGHT_RATIO, w, h*(1.0-HEIGHT_RATIO))];
    if (selects == YES)
    {
        //[titleLab setFrame:CGRectMake(0, h*HEIGHT_RATIO, w, h*(1.0-HEIGHT_RATIO))];
        //titleLab.frame = CGRectMake(0, h*HEIGHT_RATIO, w, h*(1.0-HEIGHT_RATIO));CGRectIntegral
       titleLab.font = [UIFont fontWithName:@"Arial" size:13];
        titleLab.frame = CGRectIntegral(CGRectMake(0, h*HEIGHT_RATIO+10, w, h*(1.0-HEIGHT_RATIO)-5));
    }
    if (selects == NO)
    {
        // [titleLab setFrame:CGRectMake(0, 3, w, h*HEIGHT_RATIO)];
       // titleLab.font = [UIFont fontWithName:@"AppleGothic" size:10];
        titleLab.font = [UIFont fontWithName:@"Arial" size:13];
        titleLab.numberOfLines = 2;
        titleLab.frame =CGRectIntegral (CGRectMake(2, 10, w-3, h*HEIGHT_RATIO-5));
        
        bgButton.frame = CGRectIntegral (CGRectMake(2, 10, w-3, h*HEIGHT_RATIO));

        
    }
    
    [badgeImg setFrame:CGRectMake(w-20.0, -8.0, 36, 33)];
    [badgeLab setFrame:CGRectMake(58.0, -2, 28.0, 20.0)];
}
-(void)animateRemoveSelf{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha=0.2;
        self.transform=CGAffineTransformMakeScale(0.2, 0.2);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)dealloc{
    [iconBtn release];
    [deltBtn release];
    [titleLab release];
    [badgeLab release];
    [badgeImg release];
    [super dealloc];
}

@end
