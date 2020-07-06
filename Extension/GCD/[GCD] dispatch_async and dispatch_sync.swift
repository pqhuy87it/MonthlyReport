https://stackoverflow.com/questions/19822700/difference-between-dispatch-async-and-dispatch-sync-on-serial-queue

for this code

dispatch_async(_serialQueue, ^{ printf("1"); });
printf("2");
dispatch_async(_serialQueue, ^{ printf("3"); });
printf("4");
It may print 2413 or 2143 or 1234 but 1 always before 3

for this code

dispatch_sync(_serialQueue, ^{ printf("1"); });
printf("2");
dispatch_sync(_serialQueue, ^{ printf("3"); });
printf("4");
it always print 1234

dispatch_async(_serialQueue, ^{ sleep(1000);printf("1"); });
dispatch_async(_serialQueue, ^{ printf("2"); });
What may happened is

Thread 1: dispatch_async a time consuming task (task 1) to serial queue
Thread 2: start executing task 1
Thread 1: dispatch_async another task (task 2) to serial queue
Thread 2: task 1 finished. start executing task 2
Thread 2: task 2 finished.
and you always see 12
