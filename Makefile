dev:
	k3d cluster create --config k3d/dev-env.yaml \
        --port "8080:30080@loadbalancer" \
        --port "8443:30443@loadbalancer"
	mkdir -p ~/.kube
	k3d kubeconfig get Backstage > ~/.kube/config
	helm install flux-operator oci://ghcr.io/controlplaneio-fluxcd/charts/flux-operator \
	  --namespace flux-system \
	  --create-namespace
	kubectl apply -f flux-dev.yaml

delete:
	k3d cluster delete Backstage

forward:
	kubectl port-forward svc/backstage-postgres-cluster-rw 5433:5432 &

show-password:
	@echo "backstage-postgres-cluster-app: $$(kubectl get secret backstage-postgres-cluster-app -o jsonpath='{.data.password}' | base64 -d)"

attach:
	sudo k3d kubeconfig get Backstage > ~/.kube/config
