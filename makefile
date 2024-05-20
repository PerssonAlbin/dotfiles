.PHONY: all
all: basic-installs ohmyzsh dotfiles ohmyzsh-plugins tmux neovim

.PHONY: basic-installs
basic-installs: ## Installs programs to run this
ifeq ("$(wildcard /usr/bin/curl)","")
	sudo apt-get update
	sudo apt-get install curl zsh tmux xclip cmake
endif
ifeq ("$(wildcard /usr/local/bin/nvim)","")
	git clone git@github.com:neovim/neovim.git
	cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
	cd neovim && sudo make install
endif

.PHONY: ohmyzsh
ohmyzsh: ## Install oh-my-zsh
	if [ ! -d ~/.oh-my-zsh ]; then \
		curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash; \
	fi;

.PHONY: ohmyzsh-plugins
ohmyzsh-plugins: ## Install oh-my-zsh plugins
	if [ ! -d $(HOME)/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then \
		git clone https://github.com/zsh-users/zsh-autosuggestions $(HOME)/.oh-my-zsh/custom/plugins/zsh-autosuggestions; \
	fi;
	if [ ! -d $(HOME)/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then \
		git clone https://github.com/zsh-users/zsh-syntax-highlighting $(HOME)/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting; \
	fi;
.PHONY: dotfiles
dotfiles: ## Link the dotfiles.
ifeq ("$(wildcard $(HOME)/.zshrc)","")
	echo "source $(CURDIR)/zsh/aliases.zsh" >> $(HOME)/.zshrc
	echo "source $(CURDIR)/zsh/functions.zsh" >> $(HOME)/.zshrc
	echo "source $(CURDIR)/zsh/ls_colors.zsh" >> $(HOME)/.zshrc
	echo "source $(CURDIR)/zsh/history.zsh" >> $(HOME)/.zshrc
	echo "source $(HOME)/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> $(HOME)/.zshrc
	echo "source $(HOME)/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> $(HOME)/.zshrc
endif
.PHONY: tmux
tmux: ## Symlink file to config placement
ifeq ("$(wildcard $(HOME)/.tmux.conf)","")
	ln -s $(CURDIR)/tmux/tmux.conf $(HOME)/.tmux.conf
	ln -s $(CURDIR)/tmux/tmux-files/ $(HOME)/.config/
	git clone https://github.com/tmux-plugins/tpm $(HOME)/.tmux/plugins/tpm
endif
.PHONY: neovim
neovim:
ifneq ("$(wildcard $(HOME)/.config/nvim/init.lua)","")
	rm -rf $(HOME)/.config/nvim/
	ln -s $(HOME)/.config/nvim/lua/ $(CURDIR)/nvim/
endif
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
