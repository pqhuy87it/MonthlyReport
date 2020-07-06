https://stackoverflow.com/questions/19179358/concurrent-vs-serial-queues-in-gcd

A simple example: you have a block that takes a minute to execute. You add it to a queue from the main thread. Let's look at the four cases.

async - concurrent: the code runs on a background thread. Control returns immediately to the main thread (and UI). The block can't assume that it's the only block running on that queue
async - serial: the code runs on a background thread. Control returns immediately to the main thread. The block can assume that it's the only block running on that queue
sync - concurrent: the code runs on a background thread but the main thread waits for it to finish, blocking any updates to the UI. The block can't assume that it's the only block running on that queue (I could have added another block using async a few seconds previously)
sync - serial: the code runs on a background thread but the main thread waits for it to finish, blocking any updates to the UI. The block can assume that it's the only block running on that queue
Obviously you wouldn't use either of the last two for long running processes. You normally see it when you're trying to update the UI (always on the main thread) from something that may be running on another thread.
