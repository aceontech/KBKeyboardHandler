//
//  KBKeyboardHandler.h
//  KBKeyboardHandler
//
//  Created by Alex Manarpies on 26/09/13.
//
//  Courtesy of Vladimir Grigorov
//  See http://stackoverflow.com/a/12402817/331283

#import <UIKit/UIKit.h>

@protocol KBKeyboardHandlerDelegate;

@interface KBKeyboardHandler : NSObject

- (id)init;

@property(nonatomic, weak) id<KBKeyboardHandlerDelegate> delegate;
@property(nonatomic) CGRect frame;

@end
