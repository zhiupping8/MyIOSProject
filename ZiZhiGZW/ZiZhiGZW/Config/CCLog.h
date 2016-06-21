//
//  CCLog.h
//  ZiZhiLaku2
//
//  Created by zyz on 11/29/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#ifndef CCLog_h
#define CCLog_h

#ifdef DEBUG
#define CCLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define CCLog(format, ...)
#endif


#endif /* CCLog_h */
