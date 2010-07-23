%w{
  hashie
  net/http
  crack/xml
  active_support
  active_support/core_ext/hash
}.each {|lib| require lib}

%w{
  project
  ticket
  unfuddler
}.each {|lib| require File.dirname(__FILE__) + '/unfuddler/' + lib}
