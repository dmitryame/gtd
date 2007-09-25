#!/bin/bash
export RAILS_ENV=production
export PATH=/usr/local/bin:/usr/bin:/bin:$PATH
cd /home/getitdon/gtd/jobs
ruby ./scheduled_job.rb >>log.log

