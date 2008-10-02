#!/bin/bash
export RAILS_ENV=production
export PATH=/usr/local/bin:/usr/bin:/bin:$PATH
cd /u/apps/gtd/current/jobs
ruby ./scheduled_job.rb >>log.log

