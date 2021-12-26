package boot

import (
	"strings"
)

#ArgoProject: {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "AppProject"
	M=metadata: {
		bootCluster: string
		name:        M.bootCluster
		namespace:   "argocd"
	}
	spec: {
		sourceRepos: [
			"*",
		]
		destinations: [{
			namespace: "*"
			server:    "*"
		}]
		clusterResourceWhitelist: [{
			group: "*"
			kind:  "*"
		}]
		orphanedResources: {
			warn: false
			ignore: [{
				group: "cilium.io"
				kind:  "CiliumIdentity"
			}]
		}
	}
}

#ArgoApplication: {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "Application"
	M=metadata: {
		bootCluster: string
		bootApp:     string
		name:        "\(M.bootCluster)--\(M.bootApp)"
		namespace:   "argocd"
	}
	spec: {
		project: M.bootCluster
		source: {
			repoURL:        string | *'https://github.com/amanibhavam/deploy'
			path:           string | *"c/\(M.bootCluster)/\(M.bootApp)"
			targetRevision: string | *"master"
		}
		destination: {
			name:      M.bootCluster
			namespace: string | *M.bootApp
		}
		syncPolicy: {
			automated: {
				prune:    true
				selfHeal: true
			}
			syncOptions: [ string] | *[ "CreateNamespace=true"]
		}
	}
}

#DeployBase: {
	output: {
		apiVersion: "kustomize.config.k8s.io/v1beta1"
		kind:       "Kustomization"
		metadata: [string]: string
		"resources": [upstream] + [
				for rname, r in resources {
				strings.ToLower("resource-\(r.kind)-\(r.metadata.name).yaml")
			},
		]
		"patches": [
			for pname, p in patches {
				path: strings.ToLower("patch-\(pname).yaml")
				target: {
					kind: p.kind
					name: p.name
				}
			},
		]
	}

	cname:  string
	aname:  string
	domain: string

	upstream:  string
	resources: [...] | *[]

	patches: {...} | *{}

	...
}
