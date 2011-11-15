# Cavalcade Demo

This project demos how to get started with [Cavalcade](https://github.com/freerobby/cavalcade), a lightweight infrastructure for using [Resque](https://github.com/defunkt/resque) as a stand-alone job queue.

# Getting Started

The easiest way to get started is to fork this project, rename it to whatever you want, then add your own job classes.

If you prefer to do everything yourself, you can use the following tutorial. If you're forking the project, begin at "Start Redis"

### Load the gem

If you're using bundler, your Gemfile should look like:

    source :rubygems

    gem "cavalcade"

### Create an environment.rb

Your environment.rb is responsible for loading all of the jobs and any dependencies they need to run. A barebones environment.rb that loads all jobs in the ./jobs directory looks like:

    # environment.rb - responsible for loading all resources needed to run jobs
    require "cavalcade"

    Dir[File.dirname(__FILE__) + "/jobs/*.rb"].each {|file| require file }

### Create a Rakefile

Resque uses Rake to start workers, so we need to create a Rakefile to import these tasks:

    require "./environment"
    require "resque/tasks"

### Create a job

Our demo job will give your worker a nap. Create ./jobs/sleep.rb as follows:

    class Sleep < Cavalcade::Job
      @queue = :default
      def self.perform(num_seconds)
        sleep(num_seconds)
      end
    end

### Start Redis (Start here if you're forking the demo)

You can start the redis server from a console by running `redis-server &`. Please see the [Resque documentation](https://github.com/defunkt/resque) for configuration options, but this will work out of the box for now.

### Time to roll!

Hop to a command line and run `cavalcade list-jobs`.

You should see:

> Available jobs: Sleep

Let's enqueue a few of them with different sleep times:

    cavalcade enqueue -j Sleep -p 3
    cavalcade enqueue -j Sleep -p 9
    cavalcade enqueue -j Sleep -p 25

The `-p` flag tells cavalcade that what follows are the parameters to pass to .perform(). This can be any string and may contain Ruby code. For example,

    cavalcade enqueue -j SendTweet -p 'User.last.id, "This is user #{User.last.id} tweeting to the word!"'

would resolve to

    SendTweet.perform(User.last.id, "This is user #{User.last.id} tweeting to the word!")

### Let's have a look

Resque comes with a nice Sinatra app for monitoring jobs. Start it with `resque-web` and you'll find your web browser on its interface. Select the "default" queue to view the 3 jobs.

### Start a worker

The Resque documentation provides further documentation, but for now go to a new terminal and run:

    QUEUE=* rake resque:work

Refresh the resque web monitor to see your worker in action!

## License

MIT Licensed. See LICENSE.txt for details. If you need a different license to fork this for your project, just ping me and I will add it.
