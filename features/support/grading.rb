$total_points = 0

Before do
	# log Dir.pwd
	ENV['LIBC_FATAL_STDERR_'] = "1"
end

at_exit do
	log "A total of #{$total_points} points have been awarded."
	running = `ps ef` 
	if running =~ /python.+lab4.temp/
		log "*** one or more temp processes are still running"
		#log running
		log "*** Issuing \"killall python\""
		`killall python`
	end
end
