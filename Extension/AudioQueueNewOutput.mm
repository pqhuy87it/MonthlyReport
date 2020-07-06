
#include <stdlib.h>
#include <math.h>

#include <AudioToolbox/AudioQueue.h>
#include <CoreAudio/CoreAudioTypes.h>
#include <CoreFoundation/CFRunLoop.h>


#define NUM_BUFFERS 3
#define BUFFER_SIZE 4096
#define SAMPLE_TYPE short
#define MAX_NUMBER 32767
#define SAMPLE_RATE 44100



unsigned int count;

void callback(void *custom_data, AudioQueueRef queue, AudioQueueBufferRef buffer);



int main()
{
    count = 0;
    unsigned int i;
    
    AudioStreamBasicDescription format;
    AudioQueueRef queue;
    AudioQueueBufferRef buffers[3];

    format.mSampleRate       = SAMPLE_RATE;
    format.mFormatID         = kAudioFormatLinearPCM;
    format.mFormatFlags      = kLinearPCMFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    format.mBitsPerChannel   = 8 * sizeof(SAMPLE_TYPE);
    format.mChannelsPerFrame = 2;
    format.mBytesPerFrame    = sizeof(SAMPLE_TYPE) * format.mChannelsPerFrame;
    format.mFramesPerPacket  = 1;
    format.mBytesPerPacket   = format.mBytesPerFrame * format.mFramesPerPacket;
    format.mReserved         = 0;
    
    AudioQueueNewOutput(&format, callback, NULL, CFRunLoopGetCurrent(), kCFRunLoopCommonModes, 0, &queue);
    
    for (i = 0; i < NUM_BUFFERS; i++)
    {
        AudioQueueAllocateBuffer(queue, BUFFER_SIZE, &buffers[i]);
                
        buffers[i]->mAudioDataByteSize = BUFFER_SIZE;
        
        callback(NULL, queue, buffers[i]);
    }
	
    AudioQueueStart(queue, NULL);
    
    CFRunLoopRun();    
    
    return 0;
}

void callback(void *custom_data, AudioQueueRef queue, AudioQueueBufferRef buffer)
{
    SAMPLE_TYPE *casted_buffer = (SAMPLE_TYPE *)buffer->mAudioData;
    
    unsigned int i;
        
    for (i = 0; i < BUFFER_SIZE / sizeof(SAMPLE_TYPE); i += 2)
    {
        double float_sample = sin(count / 10.0);
        
        SAMPLE_TYPE int_sample = (SAMPLE_TYPE)(float_sample * MAX_NUMBER);
        
        casted_buffer[i]   = int_sample;
        casted_buffer[i+1] = int_sample;
        
        count++;
    }
        
    AudioQueueEnqueueBuffer(queue, buffer, 0, NULL);
        
    if (count > SAMPLE_RATE * 10)
    {
        AudioQueueStop(queue, false);
        AudioQueueDispose(queue, false);
        CFRunLoopStop(CFRunLoopGetCurrent());
    }
    
}
