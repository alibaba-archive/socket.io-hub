default: generate

generate:
	rm -rf lib/*
	coffee -o lib -c src

watch:
	[ ! -f .coffee.pid ]
	coffee -w -o lib -c src 2>&1 1>/dev/null & \
	echo $$! > .coffee.pid

stop:
	[ -f .coffee.pid ] && kill $$(cat .coffee.pid) && rm .coffee.pid

.PHONY: generate
