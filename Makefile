GIT_VER := $(shell git describe --tags)
export GO111MODULE := on

packages: cmd/vecho/*.go
	cd cmd/vecho && gox -os="linux darwin" -arch="amd64" -output "../../pkg/{{.Dir}}-${GIT_VER}-{{.OS}}-{{.Arch}}" -ldflags "-s -w -X main.version=${GIT_VER}"
	cd pkg && find . -name "*${GIT_VER}*" -type f -exec zip {}.zip {} \;

release:
	ghr -u mashiike -r github-workflow-brew-tap -n "$(GIT_VER)" $(GIT_VER) pkg/

clean:
	rm -f cmd/vecho/vecho pkg/*

test:
	go test -race ./...
