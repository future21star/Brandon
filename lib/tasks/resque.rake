# Usage:
#   to move delayed queue items to the workers pools "rake resque:scheduler"
#   to process the working queues "rake resque:work"

require 'resque/tasks'
require 'resque/scheduler/tasks'
require 'resque-retry'
require 'resque/failure/redis'

ENV['QUEUE'] = '*'
task "resque:setup" => :environment

Resque::Failure::MultipleWithRetrySuppression.classes = [Resque::Failure::Redis]
Resque::Failure.backend = Resque::Failure::MultipleWithRetrySuppression

