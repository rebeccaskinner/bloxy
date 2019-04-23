CA_DIR=./ca
PRIV_DIR=${CA_DIR}/private
GEN_DIR=${CA_DIR}/generated
KEY=${PRIV_DIR}/bloxy.key.pem
CA=${CA_DIR}/bloxy.ca.pem
CERT=${GEN_DIR}/bloxy.pem
IDX=${CA_DIR}/index.txt
SERIAL=${CA_DIR}/serial

.PHONY: all
all: keys config.json

${CA_DIR}:
	mkdir -p ${CA_DIR}

${PRIV_DIR}: ${CA_DIR}
	mkdir -p ${PRIV_DIR}

${GEN_DIR}: ${CA_DIR}
	mkdir -p ${GEN_DIR}

${IDX}: ${CA_DIR}
	touch ${IDX}

${SERIAL}: ${CA_DIR}
	touch ${SERIAL}

%.key.pem: ${CA_DIR} ${PRIV_DIR}
	openssl genrsa -out $(@) 4096 -nodes

%.ca.pem: ${KEY} ${CA_DIR} ${PRIV_DIR}
	openssl req -new -x509 -key ${KEY} -out $(@) -days 30 -subj "/C=US/O=Bloxy/CN=BloxyProxy\OU=BloxyGroup" -config keygen.cnf

%.pem: ${CA} ${KEY} ${IDX} ${SERIAL} ${CA_DIR} ${PRIV_DIR} ${GEN_DIR}
	-openssl req -new -key ${KEY} -out $(@).tmp -days 30 -subj "/C=US/O=Bloxy/CN=BloxyProxy\OU=BloxyGroup" -config keygen.cnf
	-openssl ca -in $(@).tmp -out $(@) -key bloxy.key.pem -cert ${CA} -config keygen.cnf
	-rm $(@).tmp

config.json: ${CERT} config.dhall
	dhall-to-json <<< '(./config.dhall) ("${CERT}")' > config.json

.PHONY: keys
keys: ${CERT} ${CA} ${KEY}

.PHONY: clean-keys
clean-keys:
	- rm -fr ${CA_DIR}
