//
//  AsyncRequestHandler.m
//  Fitivate
//
//  Created by Rayden Lee on 25/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "AsyncOperationHandler.h"

@implementation AsyncOperationHandler
{
    NSMutableArray *_blockArray;
    int _requestCount;
    void (^_finallyBlock)();
    void (^_successBlock)();
    void (^_errorBlock)(NSArray *errors);
    BOOL _error;
    NSMutableArray *_errors;
}

- (id) init
{
    self = [super init];
    if (self) {
        _requestCount = 0;
        _error = false;
        _blockArray = [NSMutableArray new];
        _errors = [NSMutableArray new];
    }
    return self;
}

- (void) addOperation:(void (^)())block
{
    _requestCount++;
    
    [_blockArray addObject:block];
}

- (void) handleResponse
{
    @synchronized(self)
    {
        _requestCount--;
        
        [self checkComplete];
    }
}

- (void) handleErrorResponse:(NSString *)errorMessage
{
    @synchronized(self)
    {
        _error = true;
        
        [_errors addObject:errorMessage];
        
        _requestCount--;
        
        [self checkComplete];
    }
}

- (void) checkComplete
{
    if (_requestCount == 0)
    {
        [_blockArray removeAllObjects];
        
        if (_error)
        {
            _error = false;
            
            _errorBlock(_errors);
            
            [_errors removeAllObjects];
        }
        else
        {
            _successBlock();
        }
        
        _finallyBlock();
    }
}

- (void) runWithFinallyBlock:(void (^)())finallyBlock successBlock:(void (^)())successBlock errorBlock:(void (^)(NSArray *errors))errorBlock
{
    _finallyBlock = finallyBlock;
    _successBlock = successBlock;
    _errorBlock = errorBlock;
    
    for(void (^block)() in _blockArray)
    {
        block();
    }
}

@end
