default:
  @just --list

oci_uri := "githedgehog/fabricator"
airgap-chart := "zot-chart.tgz"
airgap-ref := "zot-airgap"
chart-ref := "charts/zot"
oci_repo := "127.0.0.1:30000"
hh_version := "v0.1.67-hh1"
zot_version :="v2.1.7"


helm-lint:
	helm lint .

helm-package:
	helm package . --version {{hh_version}} --app-version {{zot_version}}

push-chart:
	oras push ghcr.io/{{oci_uri}}/{{chart-ref}}:{{zot_version}} zot-{{hh_version}}.tgz

local-push: helm-lint helm-package
	oras push --plain-http {{oci_repo}}/{{oci_uri}}/{{chart-ref}}:{{zot_version}} zot-{{hh_version}}.tgz
  
local-push-airgap: helm-lint helm-package
	mv zot-{{hh_version}}.tgz {{airgap-chart}}
	docker pull --platform linux/amd64 ghcr.io/project-zot/zot-linux-amd64:{{zot_version}}
	docker save -o zot-airgap-images-amd64.tar ghcr.io/githedgehog/fabricator/zot:{{zot_version}}
	pigz -v -c zot-airgap-images-amd64.tar > zot-airgap-images-amd64.tar.gz
	oras push --plain-http {{oci_repo}}/{{oci_uri}}/{{airgap-ref}}:{{zot_version}} zot-airgap-images-amd64.tar.gz {{airgap-chart}}
 
