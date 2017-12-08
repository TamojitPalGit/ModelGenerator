//
//  ViewController.h
//  ModelGenerator
//
//  Created by Tamojit Pal on 9/29/15.
//  Copyright (c) 2015 Tamojit Pal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController
{
    NSString *strJSONName;
    NSString *strMFile;
    NSString *strHFile;
    BOOL isUp;
}
- (IBAction)SubmitAction:(id)sender;
@property (weak) IBOutlet NSTextField *txtModelName;
@property (weak) IBOutlet NSTextField *txtPath;
@property (weak) IBOutlet NSTextField *lblSuccessStatus;

@end

