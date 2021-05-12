build:
	./build-and-test.sh

clean:
	-rm -rf lambda/
	-rm lambda-deploy.zip
	-rm python/lambda-deploy.zip
	git ls-files -o python/lambda | while read f; do rm -- "$$f"; done