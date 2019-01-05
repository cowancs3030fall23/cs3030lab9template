Given /^a random small CSV file "(.*)"$/ do |csv|
	#puts "Building #{csv}"
	@csv = RandomCSV.new(csv, :small)
	#puts "Students:#{@csv.studentCount}"
end

Given /^I run local `(.*)`$/ do |cmd|
	cmd2 = cmd.gsub(/~/,Dir.home)
	#puts "'#{cmd}' is now '#{cmd2}'"
	step "I run `#{cmd2}`"
end
	
Given /^I run user `(.*)`$/ do |cmd|
	#userid = `whoami`
	userid = ENV['USER']
	cmd2 = cmd.gsub(/~/,'~' + userid)
	#puts "'#{cmd}' is now '#{cmd2}'"
	step "I run `#{cmd2}`"
end

Given /^I run user `(.*)` with random month and year$/ do |cmd|
	r = Random.new
	@randomMonth = r.rand(1..12)
	@randomYear = r.rand(1..9999)
	@months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
	@randomMonthName = @months[r.rand(0..11)]
	userid = ENV['USER']
	cmd2 = cmd.gsub(/~/,'~' + userid)
	cmd3 = "#{cmd2}#{@randomMonthName}+#{@randomYear}"
	#puts "'#{cmd}' is now '#{cmd3}'"
	step "I run `#{cmd3}`"
end

Given /^I run user `(.*)` with random year$/ do |cmd|
	r = Random.new
	@randomYear = r.rand(1..9999)
	userid = ENV['USER']
	cmd2 = cmd.gsub(/~/,'~' + userid)
	cmd3 = "#{cmd2}#{@randomYear}"
	#puts "'#{cmd}' is now '#{cmd3}'"
	step "I run `#{cmd3}`"
end

Given /^the output should contain the cal default output$/ do
	out = `cal -h`.chomp.chomp
	out2 = out.gsub(/[ ]*$/,'')
	puts "cal default output:\n#{out2}"
	step "the output should contain \"#{out2}\""
end

Given /^the output should contain the cal output with random month and year$/ do
	out = `cal -h #{@randomMonthName} #{@randomYear}`.chomp.chomp
	out2 = out.gsub(/[ ]*$/,'')
	puts "cal output of random month and year:\n#{out2}"
	step "the output should contain \"#{out2}\""
end

Given /^the output should contain the cal output with random year$/ do
	out = `cal -h #{@randomYear}`.chomp.chomp
	out2 = out.gsub(/[ ]*$/,'')
	puts "cal output with random year:\n#{out2}"
	step "the output should contain \"#{out2}\""
end

Given /^the classes table in "(.*)" should be defined correctly$/ do |db|
	dbPath = File.join("tmp","aruba",db)
	create = `sqlite3 #{dbPath} 'select count(*) from classes'`
	if create.match(/no such table/)
		raise "#{db} does not have table 'classes' defined"
	end
	create = `sqlite3 #{dbPath} '.schema classes'`
	checkFor = "id text"
	if !create.match(/#{checkFor}/)
		raise "#{db} table classes does not include column '#{checkFor}'"
	end
	checkFor = "subjcode text"
	if !create.match(/#{checkFor}/)
		raise "#{db} table classes does not include column '#{checkFor}'"
	end
	checkFor = "coursenumber text"
	if !create.match(/#{checkFor}/)
		raise "#{db} table classes does not include column '#{checkFor}'"
	end
	checkFor = "termcode text"
	if !create.match(/#{checkFor}/)
		raise "#{db} table classes does not include column '#{checkFor}'"
	end
end


Given /^the students table in "(.*)" should be defined correctly$/ do |db|
	dbPath = File.join("tmp","aruba",db)
	create = `sqlite3 #{dbPath} 'select count(*) from students'`
	if create.match(/no such table/)
		raise "#{db} does not have table 'students' defined"
	end
	create = `sqlite3 #{dbPath} '.schema students'`
	checkFor = "id text primary key unique"
	if !create.match(/#{checkFor}/)
		raise "#{db} table students does not include column '#{checkFor}'"
	end
	checkFor = "firstname text"
	if !create.match(/#{checkFor}/)
		raise "#{db} table students does not include column '#{checkFor}'"
	end
	checkFor = "lastname text"
	if !create.match(/#{checkFor}/)
		raise "#{db} table students does not include column '#{checkFor}'"
	end
	checkFor = "major text"
	if !create.match(/#{checkFor}/)
		raise "#{db} table students does not include column '#{checkFor}'"
	end
	checkFor = "email text"
	if !create.match(/#{checkFor}/)
		raise "#{db} table students does not include column '#{checkFor}'"
	end
	checkFor = "city text"
	if !create.match(/#{checkFor}/)
		raise "#{db} table students does not include column '#{checkFor}'"
	end
	checkFor = "state text"
	if !create.match(/#{checkFor}/)
		raise "#{db} table students does not include column '#{checkFor}'"
	end
	checkFor = "zip text"
	if !create.match(/#{checkFor}/)
		raise "#{db} table students does not include column '#{checkFor}'"
	end
end

Given /^the count of students from "(.*)" in "(.*)" should be correct$/ do |csv, db|
	dbPath = File.join("tmp","aruba",db)
	count = `sqlite3 #{dbPath} 'select count(*) from students'`
	if count.match(/error/i) or $?.to_i > 0
		raise "Error rc=#{$?.to_i} returned from sqlite3: #{count}"
	else
		if count.to_i != @csv.studentCount
			raise "Your student table contains #{count.to_i} rows but should contain #{@csv.studentCount}"
		end
	end
end
	
Given /^the count of classes from "(.*)" in "(.*)" should be correct$/ do |csv, db|
	dbPath = File.join("tmp","aruba",db)
	count = `sqlite3 #{dbPath} 'select count(*) from classes'`
	if count.match(/error/i) or $?.to_i > 0
		raise "Error rc=#{$?.to_i} returned from sqlite3: #{count}"
	else
		if count.to_i != @csv.classCount
			raise "Your classes table contains #{count.to_i} rows but should contain #{@csv.classCount}"
		end
	end
end
	
Given /^the students table data from "(.*)" in "(.*)" should be correct$/ do |csv, db|
	#dbPath = File.join("tmp","aruba",db)
	dbPath = db
	selectStmt = "select id,firstname,lastname,major,email,city,state,zip from students order by id;"
	# remember Ted that when using 'step' you don't prepend the path
	step "I run `sqlite3 #{dbPath} '#{selectStmt}'`"
	step "the output should not contain \"Error\""
	#puts "Output:\n#{all_output}"
	if all_output != @csv.students.join("")
		puts "Your student data:\n#{all_output}\n\nExpected student data:\n#{@csv.students.join("")}"
		raise "Student data in #{db} not as expected"
	end
	
	#pending #todo: call sqlite3 to extract and sort a count of records in his students table and compare them to my students table
end
	
Given /^the classes table data from "(.*)" in "(.*)" should be correct$/ do |csv, db|
	#dbPath = File.join("tmp","aruba",db)
	dbPath = db
	selectStmt = "select id,subjcode,coursenumber,termcode from classes order by id,subjcode,coursenumber,termcode;"
	# remember Ted that when using 'step' you don't prepend the path
	step "I run `sqlite3 #{dbPath} '#{selectStmt}'`"
	step "the output should not contain \"Error\""
	#puts "Output:\n#{all_output}"
	if all_output != @csv.classes.sort.join("")
		puts "Your classes data:\n#{all_output}\n\nExpected student data:\n#{@csv.classes.join("")}"
		raise "Classes data in #{db} not as expected"
	end
	
	#pending #todo: call sqlite3 to extract and sort a count of records in his students table and compare them to my students table
end
	
Given /^(.*) points are awarded/ do |points|
	#puts "#{points} points are now awarded!!!"
	$total_points += points.to_i
end

Given /^timeout is increased by (.*) seconds$/ do |seconds|
	if @aruba_timeout_seconds  
		@aruba_timeout_seconds += seconds.to_i
	else
		puts "aruba_timeout_seconds is NIL!"
	end
end

Given /^timeout is decreased by (.*) seconds$/ do |seconds|
	if @aruba_timeout_seconds
		@aruba_timeout_seconds -= seconds.to_i
	else
		puts "aruba_timeout_seconds is NIL!"
	end
end

