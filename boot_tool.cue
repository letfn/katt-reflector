package boot

import (
	"github.com/defn/boot"
)

command: boot.#Default.commands

command: bundle: _bundle.commands

_bundle: boot.#Bundle & {
	repo_name:     "katt-reflector"
	chart_repo:    "https://emberstack.github.io/helm-charts"
	chart_name:    "reflector"
	chart_version: "6.1.16"
	install:       "reflector"
	namespace:     "reflector"
}
