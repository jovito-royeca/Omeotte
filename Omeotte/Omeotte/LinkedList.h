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

LinkedList createNode(void* data);
void addNode(LinkedList ll, void* data);
void addNodeAtIndex(LinkedList ll, void* data, int index);
void removeNode(LinkedList ll, void* data);
void removeNodeAtIndex(LinkedList ll, int index);
void* get(LinkedList ll, int index);
int size(LinkedList ll);
void print(LinkedList ll);

#endif
