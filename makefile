all: build sync
build:
	npx quartz build
sync:
	npx quartz sync
build-test:
	npx quartz build --serve
	