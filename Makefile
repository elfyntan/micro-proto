CHECK_DIR_CMD = test -d $@ || (echo "\033[31mDirectory $@ doesn't exist\033[0m" && false)
HELP_CMD = grep -E '^[a-zA-Z_-]+:.*?\#\# .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?\#\# "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
RM_F_CMD = rm -f
RM_RF_CMD = ${RM_F_CMD} -r
.PHONY: order payment shipping help
project := order payment shipping

all: $(project) ## Generate Pbs and build

order: $@ ## Generate Pbs and build for order
payment: $@ ## Generate Pbs and build for payment
shipping: $@ ## Generate Pbs and build for shipping

$(project):
	@${CHECK_DIR_CMD}
	protoc --go_out=./golang --go_opt=paths=source_relative --go-grpc_out=./golang --go-grpc_opt=paths=source_relative $@/*.proto

test: all ## Launch tests
	go test ./...

clean: clean_order clean_payment clean_shipping ## Clean generated files

clean_order: ## Clean generated files for order
	${RM_F_CMD} golang/order/*.pb.go

clean_payment: ## Clean generated files for payment
	${RM_F_CMD} golang/payment/*.pb.go

clean_shipping: ## Clean generated files for shipping
	${RM_F_CMD} golang/shipping/*.pb.go

rebuild: clean all ## Rebuild the whole project
