build-%: %
	docker build -f $< -t quintype/docker-base:$< .

push-%: % build-%
	docker push quintype/docker-base:$<
