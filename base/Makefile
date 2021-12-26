build: clean ../main.yaml

../main.yaml: main.yaml
	kustomize build >$@

main.yaml: clean/main.yaml
	kustomize build clean >$@

clean/main.yaml: clean/values.yaml
	-helm repo add external-secrets https://external-secrets.github.io/kubernetes-external-secrets/
	helm repo update
	helm template external-secrets external-secrets/kubernetes-external-secrets \
		--version 8.3.0 --namespace=external-secrets --values=clean/values.yaml --include-crds --kube-version 1.21 >$@

.PHONY: clean
clean:
	rm -f ../main.yaml main.yaml clean/main.yaml
