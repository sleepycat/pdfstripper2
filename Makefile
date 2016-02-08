compile:
	MIX_ENV=prod mix phoenix.digest
	MIX_ENV=prod mix release

dockerize:
	docker build -t mikewilliamson/pdfstripper .

release: compile dockerize
