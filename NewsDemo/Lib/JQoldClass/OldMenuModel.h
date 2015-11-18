//
//  MenuModel.h
//  CaiDan
//
//  Created by  on 12-8-27.
//  Copyright (c) 2012年 JianQiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct{
    CGRect delRect;
    CGRect iconRect;
//    CGRect titleRect;
}MemberRect;

@protocol MenuModelDelegate;

@interface OldMenuModel : UIView<UIGestureRecognizerDelegate>{

    NSUInteger seriel;
    BOOL isActive;
    UILabel* titleLab;
    UIButton* iconBtn;
    UIButton* deltBtn;
    BOOL selects;
    UIImageView* badgeImg;
    UILabel* badgeLab;
    UIButton *bgButton;
    NSString* mark;
}
@property(nonatomic,assign)NSUInteger seriel;
@property(nonatomic)BOOL isActive, selects;
@property(nonatomic,copy)NSString* title;
@property(nonatomic,copy)NSString* icon;
@property(nonatomic,assign)NSInteger badge;
@property(nonatomic,assign)id<MenuModelDelegate> delegate;
@property(nonatomic,copy)NSString* mark;

-(void)animateRemoveSelf;
@end

@protocol MenuModelDelegate <NSObject>


-(BOOL)deleteMenuForIndex:(NSInteger)index title:(NSString*)menuTitle;
-(BOOL)selectMenuForIndex:(NSInteger)index title:(NSString*)menuTitle;

//  新方法
-(void)selectMenuForIndex:(NSInteger)index mark:(NSString*)mark title:(NSString*)menuTitle;

@end