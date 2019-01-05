Feature: Script outputs the correct data

	Scenario: cal.cgi with no parameters displays current month and year
		When I run user `lynx -nomargins -dump http://icarus.cs.weber.edu/~/cal.cgi?parameters=`
		Then the output should contain the cal default output
		Then 15 points are awarded

	Scenario: cal.cgi with random month and year parameters displays properly
		When I run user `lynx -nomargins -dump http://icarus.cs.weber.edu/~/cal.cgi?parameters=` with random month and year
		Then the output should contain the cal output with random month and year
		Then 20 points are awarded

	Scenario: cal.cgi with one random number 1-9999 displays properly
		When I run user `lynx -nomargins -dump http://icarus.cs.weber.edu/~/cal.cgi?parameters=` with random year
		Then the output should contain the cal output with random year
		Then 20 points are awarded

	Scenario: cal.cgi with an invalid year (not 1-4 digits) displays current month and year and "Invalid Parameters"
		When I run user `lynx -nomargins -dump http://icarus.cs.weber.edu/~/cal.cgi?parameters=12345`
		Then the output should contain the cal default output
		And the output should contain "Invalid Parameters"
		Then 30 points are awarded

	Scenario: cal.cgi with an invalid month number and a valid year displays current month and year and "Invalid Parameters"
		When I run user `lynx -nomargins -dump http://icarus.cs.weber.edu/~/cal.cgi?parameters=17+2015`
		Then the output should contain the cal default output
		And the output should contain "Invalid Parameters"
		Then 30 points are awarded

	Scenario: cal.cgi with a valid month and an invalid year displays current month and year and "Invalid Parameters"
		When I run user `lynx -nomargins -dump http://icarus.cs.weber.edu/~/cal.cgi?parameters=May+12345`
		Then the output should contain the cal default output
		And the output should contain "Invalid Parameters"
		Then 30 points are awarded

	Scenario: cal.cgi with an invalid month name and a valid year displays current month and year and "Invalid Parameters"
		When I run user `lynx -nomargins -dump http://icarus.cs.weber.edu/~/cal.cgi?parameters=Feberrwary+2015`
		Then the output should contain the cal default output
		And the output should contain "Invalid Parameters"
		Then 30 points are awarded

