##Jobs

What should you run in the background? Anything that takes any time at all. Slow INSERT statements, disk manipulating, data processing, etc.

At GitHub we use Resque to process the following types of jobs:

Warming caches
Counting disk usage
Building tarballs
Building Rubygems
Firing off web hooks
Creating events in the db and pre-caching them
Building graphs
Deleting users
Updating our search index

As of writing we have about 35 different types of background jobs.

Keep in mind that you don't need a web app to use Resque - we just mention "foreground" and "background" because they make conceptual sense. You could easily be spidering sites and sticking data which needs to be crunched later into a queue.

##google: word segmentation
##google: what types of background jobs in rails 


