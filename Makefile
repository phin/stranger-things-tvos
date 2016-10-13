RSYNC=rsync

all: prod

prod: 
	$(RSYNC) -avz -e ssh *.{php,json} user@yourserver.com:dev/stranger-things-wall/