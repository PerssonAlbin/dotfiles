.PHONY: all
all: dotfiles ohmyzsh ohmyzsh-plugins


.PHONY: ohmyzsh
ohmyzsh: ## Install oh-my-zsh
	if [ ! -d ~/.oh-my-zsh ]; then \
		curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash; \
	fi;

.PHONY: ohmyzsh-plugins
ohmyzsh-plugins: ## Install oh-my-zsh plugins
	git clone https://github.com/zsh-users/zsh-autosuggestions $(HOME)/.oh-my-zsh/custom/plugins/zsh-autosuggestions

.PHONY: dotfiles
dotfiles: ## Link the dotfiles.
ifneq ("$(wildcard $(HOME)/.zshrc)","")
	echo "source $(CURDIR)/zsh/aliases.zsh" >> $(HOME)/.zshrc
	echo "source $(CURDIR)/zsh/functions.zsh" >> $(HOME)/.zshrc
endif
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'