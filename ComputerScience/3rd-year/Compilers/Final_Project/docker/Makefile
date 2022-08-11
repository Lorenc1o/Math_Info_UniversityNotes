all: Dockerfile
	docker images 2>&1 | grep -qe ubuntu/comp || docker build -t ubuntu/comp:r1 .

run:
	docker run -it --rm \
		-h compiladores \
		-v `pwd`/..:/home/alumno --name comp ubuntu/comp:r1


.PHONY: all run run-nox run-gdb
