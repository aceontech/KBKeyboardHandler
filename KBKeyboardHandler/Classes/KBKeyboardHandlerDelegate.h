//
//  KBKeyboardHandlerDelegate.h
//  KBKeyboardHandler
//
//  Created by Alex Manarpies on 26/09/13.
//
//  Courtesy of Vladimir Grigorov
//  See http://stackoverflow.com/a/12402817/331283

@protocol KBKeyboardHandlerDelegate <NSObject>

- (void)keyboardSizeWillChange:(CGSize)delta;
- (void)keyboardSizeDidChange:(CGSize)delta;

@end
