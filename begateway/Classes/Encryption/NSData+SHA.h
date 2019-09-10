//
//  NSData+SHA.h
//  Pods
//
//  Created by FEDAR TRUKHAN on 9/2/19.
//

//#ifndef NSData_SHA_h
//#define NSData_SHA_h
#import <Foundation/Foundation.h>

@interface NSData (NSData_SwiftyRSASHA)
    
- (nonnull NSData*) SwiftyRSASHA1;
- (nonnull NSData*) SwiftyRSASHA224;
- (nonnull NSData*) SwiftyRSASHA256;
- (nonnull NSData*) SwiftyRSASHA384;
- (nonnull NSData*) SwiftyRSASHA512;
    
    @end


//#endif /* NSData_SHA_h */
