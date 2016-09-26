every 1.hour do 
	rake 'send_digest_email', environment: 'development'
end