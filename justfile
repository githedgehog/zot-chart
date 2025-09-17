default:
  @just --list

oci_uri := "githedgehog/fabricator"
airgap-chart := "zot-chart.tgz"
airgap-ref := "zot-airgap"
chart-ref := "charts/zot"
oci_repo := "127.0.0.1:30000"
hh_version := `git describe --tag --dirty --always`
zot_version :="v2.1.7"


helm-lint:
	helm lint .

helm-package:
	helm package . --version {{hh_version}} --app-version {{zot_version}}

push-chart:
	helm push zot-{{hh_version}}.tgz oci://{{oci_repo}}/{{oci_uri}}/{{chart-ref}}

local-push: helm-lint helm-package
	helm push --plain-http zot-{{hh_version}}.tgz oci://{{oci_repo}}/{{oci_uri}}/{{chart-ref}}

local-push-airgap: helm-lint helm-package
	mv zot-{{hh_version}}.tgz {{airgap-chart}}
	docker pull --platform linux/amd64 ghcr.io/project-zot/zot-linux-amd64:{{zot_version}}
	docker save -o zot-airgap-images-amd64.tar ghcr.io/githedgehog/fabricator/zot:{{zot_version}}
	pigz -v -c zot-airgap-images-amd64.tar > zot-airgap-images-amd64.tar.gz
	oras push --plain-http {{oci_repo}}/{{oci_uri}}/{{airgap-ref}}:{{zot_version}} zot-airgap-images-amd64.tar.gz {{airgap-chart}}
 
