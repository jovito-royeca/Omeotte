//
//  LinkedList.c
//  Omeotte
//
//  Created by Jovito Royeca on 9/19/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "LinkedList.h"

LinkedList createNode(void* data)
{
    LinkedList me = (LinkedList) malloc(sizeof(struct _LinkedList));

    me->data = malloc(sizeof(data));
    memcpy(me->data, data, sizeof(data));
    me->next = NULL;
    return me;
}

void addNode(LinkedList ll, void* data)
{
    LinkedList curr = ll;
    
    while (curr)
    {
        if (curr->next == NULL)
        {
            LinkedList newLL = createNode(data);
            curr->next = newLL;
            break;
        }
        else
        {
            curr = curr->next;
        }
    }
}

void addNodeAtIndex(LinkedList ll, void* data, int index)
{
    LinkedList curr = ll;
    LinkedList prev = NULL;
    LinkedList newLL = createNode(data);
    int added = 0, i = 0;;
    
    while (curr)
    {
        if (i == index)
        {
            if (prev)
            {
                prev->next = newLL;
            }
            newLL->next = curr;
            curr = newLL;
            added = 1;
            break;
        }
        else
        {
            prev = curr;
            curr = curr->next;
        }
        i++;
    }
    
    /* index > size, let's just add at the end */
    if (!added && !prev)
    {
        prev->next = newLL;
    }
}

void removeNode(LinkedList ll, void* data)
{
    LinkedList curr = ll;
    LinkedList prev = NULL;
    
    while (curr)
    {
        if (memcmp(curr->data, data, sizeof(data)))
        {
            if (prev)
            {
                prev->next = curr->next;
            }
            free(curr);
        }
//        else
//        {
            prev = curr;
            curr = curr->next;
//        }
    }
}

void removeNodeAtindex(LinkedList ll, int index)
{
    LinkedList curr = ll;
    LinkedList prev = NULL;
    int i = 0;
    
    while (curr)
    {
        if (i == index)
        {
            if (prev)
            {
                prev->next = curr->next;
            }
            free(curr);
            break;
        }
        else
        {
            prev = curr;
            curr = curr->next;
            i++;
        }
    }
}

void* get(LinkedList ll, int index)
{
    if (index > size(ll))
        return NULL;
    
    LinkedList curr = ll;
    void *data = NULL;
    int i = 0;
    
    while (curr)
    {
        if (i == index)
        {
            data =  curr->data;
            break;
        }
        curr = curr->next;
    }
    
    return data;
}

int size(LinkedList ll)
{
    int size = 0;
    LinkedList curr = ll;
    
    while (curr)
    {
        size++;
        
        if (curr)
        {
            curr = curr->next;
        }
    }
    
    return size;
}

void print(LinkedList ll)
{
    LinkedList curr = ll;
    int i = 0;
    
    printf("[%d] {", size(ll));
    while (curr)
    {
        printf("%d:%d, ", i, *((int*)curr->data));
        curr = curr->next;
        i++;
    }
    printf("}\n");
}