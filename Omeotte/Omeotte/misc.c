//
//  misc.c
//  Omeotte
//
//  Created by Jovito Royeca on 9/18/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#include "Omeotte.h"

int compare(int op1, int op2)
{
    int result = 0;
    
    if (op1 < op2)
    {
        result = -1;
    }
    else if (op1 == op2)
    {
        result = 0;
    }
    else if (op1 > op2)
    {
        result = 1;
    }
    
    return result;
}

int randomNumber(int min, int max)
{
    int result=0, low=0, hi=0;
    
    if(min<max)
    {
        low = min;
        hi = max+1; // this is done to include max_num in output.
    }
    else
    {
        low = max+1;// this is done to include max_num in output.
        hi = min;
    }
    
    srand(time(NULL));
    result = (rand()%(hi-low))+low;
    return result;
}

