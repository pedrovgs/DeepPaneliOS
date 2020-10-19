//
//  DeepPaneliOSWrapper.h
//  DeepPanel
//
//  Created by Pedro Gómez on 11/10/2020.
//  Copyright © 2020 Pedro Gómez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RawPanelsInfo.h"

#ifndef DeepPaneliOSWrapper_h
#define DeepPaneliOSWrapper_h

@interface DeepPaneliOSWrapper : NSObject
- (RawPanelsInfo *) extractPanelsInfo:(float *)prediction andScale:(float)scale andOriginalImageWidth:(int)originalImageWidth andOriginalImageHeigth:(int)originalImageHeight;

@end

#endif /* DeepPaneliOSWrapper_h */
