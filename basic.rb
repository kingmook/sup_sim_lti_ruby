#Very basic example of an LTI provider in Ruby using Sinatra
#Based on examples from https://github.com/instructure/ims-lti 

#Need the basic rubygems and the sinatra gems (for this example)
#We must include the ims/lti and OAuth gems (regardless of environment)
require 'rubygems'
require 'sinatra'
require 'ims/lti'
require 'oauth/request_proxy/rack_request'

#LTI key and secret hash declaration
lti_auth = {"key" => "key", "secret" => "secret"}

#Define index path
post '/' do
  #Check if the correct key is being sent
  if lti_auth["key"] == params[:oauth_consumer_key]

    #Build our LTI object with the credentials as we know them 
    provider = IMS::LTI::ToolProvider.new(lti_auth["key"], lti_auth["secret"], params)

    #Make sure our LTI object's OAuth connection is valid
    if provider.valid_request?(request)
      "Successful LTI connection made. Here's what we got: <br /><hr />" +params.inspect
    #We already checked the key so it's likely the user is using the wrong secret to generate their OAuth object
	else
      "Bad OAuth. Probably sent wrong secret"
    end
  
  #Wrong key  
  else
    "Wrong key passed"
  end
end
