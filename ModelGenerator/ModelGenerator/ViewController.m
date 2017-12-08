//
//  ViewController.m
//  ModelGenerator
//
//  Created by Tamojit Pal on 9/29/15.
//  Copyright (c) 2015 Tamojit Pal. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController




//***************************************************************************************************************
-(void)creatMFile:(NSString *)strInterfaceName
{
    if(![strInterfaceName isEqualToString:strJSONName])
    {
        strMFile=[NSString stringWithFormat:@"%@\n@implementation %@%@\n+(BOOL)propertyIsOptional:(NSString*)propertyName\n{\nreturn YES;\n}\n@end",strMFile,strJSONName,[[strInterfaceName capitalizedString] stringByReplacingOccurrencesOfString:@"_" withString:@""]];
    }
    else
    {
        strMFile=[NSString stringWithFormat:@"%@\n@implementation %@\n+(BOOL)propertyIsOptional:(NSString*)propertyName\n{\nreturn YES;\n}\n@end",strMFile,[[strInterfaceName capitalizedString] stringByReplacingOccurrencesOfString:@"_" withString:@""]];
    }
}

-(void)dictArrCheck:(NSArray *)arr withDict:(NSDictionary *)dict
{
    for(int i=0;i<[arr count];i++)
    {
        if([[dict valueForKey:[arr objectAtIndex:i]] isKindOfClass:[NSArray class]] )
        {
            if([[dict valueForKey:[arr objectAtIndex:i]] count])
            {
                if([[[dict valueForKey:[arr objectAtIndex:i]] objectAtIndex:0] isKindOfClass:[NSDictionary class]])
                {
                    strHFile=[NSString stringWithFormat:@"@end\n%@",strHFile];
                    isUp=true;
                    [self logAll:[[[dict valueForKey:[arr objectAtIndex:i]] objectAtIndex:0] allKeys]  withDict:[[dict valueForKey:[arr objectAtIndex:i]] objectAtIndex:0]];
                    strHFile=[NSString stringWithFormat:@"@interface %@ : JSONModel\n%@",[self capitalizedString:[[arr objectAtIndex:i] stringByReplacingOccurrencesOfString:@"_" withString:@""]],strHFile];
                    [self creatMFile:[arr objectAtIndex:i]];
                    strHFile=[NSString stringWithFormat:@"@protocol %@\n@end\n%@",[self capitalizedString:[[arr objectAtIndex:i] stringByReplacingOccurrencesOfString:@"_" withString:@""]],strHFile];
                    isUp=false;
                    [self dictArrCheck:[[[dict valueForKey:[arr objectAtIndex:i]] objectAtIndex:0] allKeys] withDict:[[dict valueForKey:[arr objectAtIndex:i]] objectAtIndex:0]];
                }
            }
        }
        else if([[dict valueForKey:[arr objectAtIndex:i]] isKindOfClass:[NSDictionary class]] )
        {
            strHFile=[NSString stringWithFormat:@"@end\n%@",strHFile];
            isUp=true;
            [self logAll:[[dict valueForKey:[arr objectAtIndex:i]] allKeys]  withDict:[dict valueForKey:[arr objectAtIndex:i]]];
            strHFile=[NSString stringWithFormat:@"@interface %@ : JSONModel\n%@",[self capitalizedString:[[arr objectAtIndex:i] stringByReplacingOccurrencesOfString:@"_" withString:@""]],strHFile];
            [self creatMFile:[arr objectAtIndex:i]];
            isUp=false;
            [self dictArrCheck:[[dict valueForKey:[arr objectAtIndex:i]] allKeys] withDict:[dict valueForKey:[arr objectAtIndex:i]]];
        }
    }
    
}

-(void)logAll:(NSArray *)arr withDict:(NSDictionary *)dict
{
    for(int i=0;i<[arr count];i++)
    {
        if([[dict valueForKey:[arr objectAtIndex:i]] isKindOfClass:[NSArray class]] )
        {
            if([[dict valueForKey:[arr objectAtIndex:i]] count])
            {
                if(![[[dict valueForKey:[arr objectAtIndex:i]] objectAtIndex:0] isKindOfClass:[NSDictionary class]])
                {
                    if(isUp)
                    {
                        strHFile=[NSString stringWithFormat:@"@property(nonatomic,strong) NSArray *%@;\n%@",[arr objectAtIndex:i],strHFile];
                    }
                    else
                    {
                        strHFile=[NSString stringWithFormat:@"%@\n@property(nonatomic,strong) NSArray *%@;",strHFile,[arr objectAtIndex:i]];
                    }
                }
                else
                {
                    if(isUp)
                    {
                        strHFile=[NSString stringWithFormat:@"@property(nonatomic,strong) NSArray<%@> *%@;\n%@",[[self capitalizedString:[arr objectAtIndex:i]] stringByReplacingOccurrencesOfString:@"_" withString:@""],[arr objectAtIndex:i],strHFile];
                    }
                    else
                    {
                        strHFile=[NSString stringWithFormat:@"%@\n@property(nonatomic,strong) NSArray<%@>  *%@;",strHFile,[[self capitalizedString:[arr objectAtIndex:i]] stringByReplacingOccurrencesOfString:@"_" withString:@""],[arr objectAtIndex:i]];
                    }
                }
            }
        }
        else if([[dict valueForKey:[arr objectAtIndex:i]] isKindOfClass:[NSDictionary class]] )
        {
            if(isUp)
            {
                strHFile=[NSString stringWithFormat:@"@property(nonatomic,strong) %@ *%@;\n%@",[[self capitalizedString:[arr objectAtIndex:i]] stringByReplacingOccurrencesOfString:@"_" withString:@""],[arr objectAtIndex:i],strHFile];
            }
            else
            {
                strHFile=[NSString stringWithFormat:@"%@\n@property(nonatomic,strong) %@ *%@;",strHFile,[[self capitalizedString:[arr objectAtIndex:i]] stringByReplacingOccurrencesOfString:@"_" withString:@""],[arr objectAtIndex:i]];
            }
        }
        else if([[dict valueForKey:[arr objectAtIndex:i]] isKindOfClass:[NSString class]] )
        {
            if(isUp)
            {
                strHFile=[NSString stringWithFormat:@"@property (nonatomic,strong) NSString *%@;\n%@",[arr objectAtIndex:i],strHFile];
            }
            else
            {
                strHFile=[NSString stringWithFormat:@"%@\n@property (nonatomic,strong) NSString  *%@;",strHFile,[arr objectAtIndex:i]];
            }
        }
        else if([[dict valueForKey:[arr objectAtIndex:i]] isKindOfClass:[NSNumber class]] )
        {
            if(isUp)
            {
                strHFile=[NSString stringWithFormat:@"@property (nonatomic,strong) NSNumber *%@;\n%@",[arr objectAtIndex:i],strHFile];
            }else
            {
                strHFile=[NSString stringWithFormat:@"%@\n@property (nonatomic,strong) NSNumber  *%@;",strHFile,[arr objectAtIndex:i]];
            }
        }
    }
    
}

-(void)testCode2
{
    strMFile=@"";
    strJSONName=self.txtModelName.stringValue;
    NSString *filePath = self.txtPath.stringValue;
    NSData *dataJSON = [NSData dataWithContentsOfFile:filePath];
    NSError *jsonParsingError = nil;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:dataJSON options:0 error:&jsonParsingError];
    strHFile=@"#import \"JSONModel.h\"\n\n";
    strHFile=[NSString stringWithFormat:@"@interface %@ : JSONModel",[strJSONName stringByReplacingOccurrencesOfString:@"_" withString:@""]];
    [self creatMFile:strJSONName];
    [self logAll:[responseObject allKeys] withDict:responseObject];
    strHFile=[NSString stringWithFormat:@"%@\n@end",strHFile];
    [self dictArrCheck:[responseObject allKeys] withDict:responseObject];
    NSLog(@"strHFile\n%@",strHFile);
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains (NSDesktopDirectory, NSUserDomainMask, YES);
    NSString * desktopPath = [paths objectAtIndex:0];
    
    [self writeToTextFile:desktopPath withFileName:[NSString stringWithFormat:@"%@.h",strJSONName] withDataString:strHFile];
    [self writeToTextFile:desktopPath withFileName:[NSString stringWithFormat:@"%@.m",strJSONName] withDataString:strMFile];
    [self SuccessMessage];

}


-(void) writeToTextFile:(NSString *)path withFileName:(NSString *)fileName withDataString:(NSString *)strData
{
    NSString *fileLocation_Name = [NSString stringWithFormat:@"%@/%@",
                          path,fileName];
    [strData writeToFile:fileLocation_Name
               atomically:NO
                 encoding:NSStringEncodingConversionAllowLossy
                    error:nil];
}

-(void)SuccessMessage
{
    self.lblSuccessStatus.hidden=NO;
}

-(NSString *)capitalizedString:(NSString *)str
{
    return [NSString stringWithFormat:@"%@%@",[strJSONName capitalizedString],[str capitalizedString]];
}
//********************************************************************************************************************
- (void)viewDidLoad {
    [super viewDidLoad];
    self.lblSuccessStatus.hidden=YES;
    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)SubmitAction:(id)sender {
    [self testCode2];
}
@end
