Feature: Files must be named "cal.html" and "cal.cgi" and be marked as executable
	Scenario: cal.html and cal.cgi must be found
		Then a file named "~/public_html/cal.html" should exist
		Then a file named "~/public_html/cal.cgi" should exist
		Then 5 points are awarded

	Scenario: cal.html and cal.cgi must be executable
		#Then the mode of filesystem object "~/public_html/cal.html" should match "0755"
		Given the file named "~/public_html/cal.html" should have permissions "0755"
		And the file named "~/public_html/cal.cgi" should have permissions "0755"
		Then 5 points are awarded

	Scenario: cal.cgi must not contain YOUR NAME GOES HERE
		Given the file "~/public_html/cal.cgi" should not contain "YOUR NAME GOES HERE"
		Then 15 points are awarded
