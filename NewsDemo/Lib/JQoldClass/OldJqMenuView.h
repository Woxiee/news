//
//  MenuView.h
//  CaiDan
//
//  Created by  on 12-9-9.
//  Copyright (c) 2012年 JianQiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol jqMenuViewDelegate;

#import "OldMenuModel.h"

@interface OldJqMenuView : UIScrollView<UIGestureRecognizerDelegate,MenuModelDelegate>{
    NSUInteger row;
    NSUInteger column;
    BOOL enableMultiply;
    BOOL enableEdit;
    CGFloat elementHeight;
    CGFloat elementWidth;
@public
    BOOL param;
}

@property(nonatomic,assign)id<jqMenuViewDelegate> menuDelegate;
@property(nonatomic,assign)BOOL enableMultiply;
@property(nonatomic,assign)BOOL enableEdit;

-(void)addMenuForIndex:(NSInteger)index icon:(NSString *)iconName title:(NSString *)name mark:(NSString*)mark;

-(void)addMenuaddbtn:(NSInteger)fromIndex;
-(void)layoutRow:(NSUInteger)rowNum column:(NSUInteger)columnNum;
-(void)setElementWidth:(CGFloat)w height:(CGFloat)h;
-(void)addMenuForIndex:(NSInteger)index icon:(NSString *)iconName title:(NSString *)name badge:(NSInteger)badge active:(BOOL)yesOrNo selects:(BOOL)selc;
-(void)insertMenuForIndex:(NSInteger)index icon:(NSString *)iconName title:(NSString *)name badge:(NSInteger)badge active:(BOOL)yesOrNo selects:(BOOL)selc;

-(void)deletemenutoindex:(NSInteger)index;
-(void)endEditing;
NSComparisonResult compare(OldMenuModel *first, OldMenuModel *second,void *context);
NSComparisonResult compareSeriel(NSDictionary *firstDict, NSDictionary *secondDict,void *context);
@end

@protocol jqMenuViewDelegate <NSObject>

@optional
-(void)menuView:(OldJqMenuView*)view clickedMenuAtIndex:(NSInteger)index title:(NSString*)theTitle;
-(void)menuView:(OldJqMenuView*)view deleteMenuAtIndex:(NSInteger)index title:(NSString*)theTitle;
-(void)menuView:(OldJqMenuView*)view clickedMultiplicationMenu:(NSInteger)index;
-(void)menuView:(OldJqMenuView*)view moveMenuFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex title:(NSString*)theTitle;
-(void)menuView:(OldJqMenuView *)view didEndEditing:(NSArray*)titleArray; 
-(BOOL)menuView:(OldJqMenuView *)view shouldDeleteMenuForIndex:(NSInteger)index title:(NSString *)menuTitle;

//新方法
-(void)menuView:(OldJqMenuView*)view clickedMenuWithMark:(NSString*)mark title:(NSString*)theTitle;
//-(void)menuView:(jqMenuView*)view deleteMenuAtIndex:(NSInteger)index title:(NSString*)theTitle;
//-(void)menuView:(jqMenuView*)view clickedMultiplicationMenu:(NSInteger)index;
//-(void)menuView:(jqMenuView*)view moveMenuFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex title:(NSString*)theTitle;
//-(void)menuView:(jqMenuView *)view didEndEditing:(NSArray*)titleArray; 
//-(BOOL)menuView:(jqMenuView *)view shouldDeleteMenuForIndex:(NSInteger)index title:(NSString *)menuTitle;

@end


