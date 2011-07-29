#!/usr/bin/env ruby

tests = 0
assertions = 0
failures = 0
errors = 0

args = ARGV.join(" ")

IO.popen("lein test #{args}").each_line do |line|
  puts line
  # Ran 16 tests containing 34 assertions.
  # 0 failures, 0 errors.
  if line =~ /Ran (\d+) tests containing (\d+) assertions./
    tests = $1
    assertions =$2
  end
  if line =~ /(\d+) failures, (\d+) errors./
    failures = $1
    errors = $2
  end
end

Process.wait
status = $? == 0 ? "SUCCESS" : "FAILURE"

# Growl
#puts "Ran #{tests} tests with #{assertions} assertions, #{(tests.to_i - failures.to_i)} successful, #{failures} failures, #{errors} errors."
`growlnotify -m "Ran #{tests} tests with #{assertions} assertions, #{(tests.to_i - failures.to_i)} successful, #{failures} failures, #{errors} errors." -t "#{status}: lein test #{args}"`

