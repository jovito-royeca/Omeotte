//
//  LinkedList.h
//  Omeotte
//
//  Created by Jovito Royeca on 9/19/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#ifndef Omeotte_LinkedList_h
#define Omeotte_LinkedList_h

typedef struct _LinkedList
{
    void *data;
//    struct _LinkedList *previous;
    struct _LinkedList *next;
} *LinkedList;

LinkedList ll_create();
void ll_add(LinkedList ll, void* data);
void ll_addAtIndex(LinkedList ll, void* data, int index);
void ll_remove(LinkedList ll, void* data);
void ll_removeAtIndex(LinkedList ll, int index);
void* ll_get(LinkedList ll, int index);
int ll_size(LinkedList ll);
void ll_print(LinkedList ll);

#endif
