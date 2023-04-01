.PHONY: build
build:
	@npx hexo generate

.PHONY: clean
clean:
	@npx hexo clean

.PHONY: serve
serve:
	@npx hexo server -p 12000

.PHONY: http-static
http-static:
	@npx http-server -c-1 -p 80 ./public

.PHONY: init
init: themes/hexo-theme-fluid node_modules

themes/hexo-theme-fluid:
	@git clone https://github.com/adoyle-h/hexo-theme-fluid.git themes/hexo-theme-fluid

node_modules:
	@npm install
