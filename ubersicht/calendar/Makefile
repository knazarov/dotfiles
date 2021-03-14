all: calendar.widget.zip

calendar.widget.zip: calendar.coffee install.command
	mkdir -p calendar.widget
	cp calendar.coffee install.command calendar.widget
	zip $@ calendar.widget/*
	rm -rf calendar.widget

clean:
	rm calendar.widget.zip
	rm -rf calendar.widget
