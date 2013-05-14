build:
	mkdir -p lib
	rm -rf lib/*
	node_modules/.bin/coffee --compile -m --output lib/ src/

watch:
	node_modules/.bin/coffee --watch --compile --output lib/ src/
	
test:
	node_modules/.bin/mocha

jumpstart:
	npm install
	curl -u 'meryn' https://api.github.com/user/repos -d '{"name":"memoblock", "description":"A memory device for promise chains.","private":false}'
	mkdir -p src
	touch src/memoblock.coffee
	mkdir -p test
	touch test/memoblock.coffee
	git init
	git remote add origin git@github.com:meryn/memoblock
	git add .
	git commit -m "jumpstart commit."
	git push -u origin master

.PHONY: test build