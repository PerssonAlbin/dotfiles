.PHONY: all
all: deps ohmyzsh dotfiles tmux neovim alacritty

.PHONY: neovim
neovim: neovim-install neovim-verify neovim-config

.PHONY: deps
deps: deps-install deps-verify

.PHONY: ohmyzsh
ohmyzsh: ohmyzsh-install ohmyzsh-plugins ohmyzsh-verify

.PHONY: alacritty
alacritty: alacritty-config

.PHONY: tmux
tmux: tmux-config

PKG_MANAGER := $(shell \
	if command -v apt-get >/dev/null 2>&1; then echo "apt-get"; \
	elif command -v yum >/dev/null 2>&1; then echo "yum"; \
	elif command -v dnf >/dev/null 2>&1; then echo "dnf"; \
	elif command -v brew >/dev/null 2>&1; then echo "brew"; \
	elif command -v pacman >/dev/null 2>&1; then echo "pacman"; \
	elif command -v zypper >/dev/null 2>&1; then echo "zypper"; \
	elif command -v apk >/dev/null 2>&1; then echo "apk"; \
	elif command -v pkg >/dev/null 2>&1; then echo "pkg"; \
	elif command -v emerge >/dev/null 2>&1; then echo "emerge"; \
	else echo "unknown"; fi)

DEPENDENCIES := curl zsh tmux xclip cmake

.PHONY: deps-install
deps-install: ## Install dependencies
	@echo "=== Installing Dependencies ==="
	@echo "Using $(PKG_MANAGER) to install dependencies"
	@case "$(PKG_MANAGER)" in \
		apt-get) sudo apt-get update -qq >/dev/null 2>&1 && sudo apt-get install -y $(DEPENDENCIES) -qq >/dev/null 2>&1 ;; \
		yum) sudo yum install -y $(DEPENDENCIES) -q >/dev/null 2>&1 ;; \
		dnf) sudo dnf install -y $(DEPENDENCIES) -q >/dev/null 2>&1 ;; \
		brew) brew install $(DEPENDENCIES) >/dev/null 2>&1 ;; \
		pacman) sudo pacman -S --noconfirm --quiet $(DEPENDENCIES) >/dev/null 2>&1 ;; \
		zypper) sudo zypper --quiet install -y $(DEPENDENCIES) >/dev/null 2>&1 ;; \
		apk) sudo apk add --quiet $(DEPENDENCIES) >/dev/null 2>&1 ;; \
		pkg) sudo pkg install -y $(DEPENDENCIES) >/dev/null 2>&1 ;; \
		emerge) sudo emerge -q $(DEPENDENCIES) >/dev/null 2>&1 ;; \
		*) echo "No supported package manager found. Please install dependencies manually." && exit 1 ;; \
	esac
	@echo "Installation finished!"

.PHONY: deps-verify
deps-verify: ## Verify installation of dependencies
	@echo "=== Verifying Dependencies ==="
	@echo "Checking if all dependencies are installed..."
	@missing=0; \
	for dep in $(DEPENDENCIES); do \
		echo -n "Checking $$dep... "; \
		case "$(PKG_MANAGER)" in \
			apt-get) \
				if dpkg -l | grep -q "^ii[ ]*$$dep "; then \
					echo "✓ Installed"; \
				else \
					echo "✗ Not installed"; \
					missing=1; \
				fi ;; \
			yum|dnf) \
				if rpm -q $$dep >/dev/null 2>&1; then \
					echo "✓ Installed"; \
				else \
					echo "✗ Not installed"; \
					missing=1; \
				fi ;; \
			brew) \
				if brew list $$dep >/dev/null 2>&1; then \
					echo "✓ Installed"; \
				else \
					echo "✗ Not installed"; \
					missing=1; \
				fi ;; \
			pacman) \
				if pacman -Q $$dep >/dev/null 2>&1; then \
					echo "✓ Installed"; \
				else \
					echo "✗ Not installed"; \
					missing=1; \
				fi ;; \
			zypper) \
				if rpm -q $$dep >/dev/null 2>&1; then \
					echo "✓ Installed"; \
				else \
					echo "✗ Not installed"; \
					missing=1; \
				fi ;; \
			apk) \
				if apk info -e $$dep >/dev/null 2>&1; then \
					echo "✓ Installed"; \
				else \
					echo "✗ Not installed"; \
					missing=1; \
				fi ;; \
			pkg) \
				if pkg info -e $$dep >/dev/null 2>&1; then \
					echo "✓ Installed"; \
				else \
					echo "✗ Not installed"; \
					missing=1; \
				fi ;; \
			emerge) \
				if qlist -I $$dep >/dev/null 2>&1; then \
					echo "✓ Installed"; \
				else \
					echo "✗ Not installed"; \
					missing=1; \
				fi ;; \
			*) \
				echo "? Cannot verify (unknown package manager)"; \
				missing=1; \
		esac; \
	done; \
	if [ $$missing -eq 0 ]; then \
		echo "All dependencies are installed!"; \
		exit 0; \
	else \
		echo "ERROR: Some dependencies are missing."; \
		exit 1; \
	fi

.PHONY: neovim-install
neovim-install: ## Install Neovim from source
	@echo "=== Installing Neovim ==="
	@echo "Checking for Neovim..."
	@if command -v nvim >/dev/null 2>&1; then \
		echo "Neovim is already installed."; \
	else \
		echo "Installing Neovim..."; \
		git clone git@github.com:neovim/neovim.git ../; \
		cd ../neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo; \
		cd ../neovim && sudo make install; \
		echo "Installation finished!"; \
	fi

.PHONY: neovim-verify
neovim-verify: ## Verify Neovim installation
	@echo "=== Verifying Neovim Installation ==="
	@echo -n "Checking for Neovim...	"
	@if command -v nvim >/dev/null 2>&1; then \
		echo "✓ Installed"; \
	else \
		echo "✗ Not installed"; \
		exit 1; \
	fi

.PHONY: neovim-config
neovim-config: ## Link neovim config
	@echo "=== Linking Neovim Config ==="
	@if [ -L "$(HOME)/.config/nvim" ]; then \
		echo "Neovim config is already linked!"; \
	else \
		echo "Replacing configuration"; \
		rm -rf $(HOME)/.config/nvim/; \
		ln -s $(CURDIR)/nvim $(HOME)/.config/nvim; \
		echo "Configuration has been replaced"; \
	fi

.PHONY: ohmyzsh-install
ohmyzsh-install: ## Install oh-my-zsh
	@echo "=== Installing Oh-my-zsh ==="
	@echo "Checking for Zsh..."
	@if command -v zsh >/dev/null 2>&1; then \
		echo "Found Zsh!"; \
		echo "Checking for oh-my-zsh..."; \
		if [ -d $(HOME)/.oh-my-zsh ]; then \
			echo "Oh-my-zsh is already installed."; \
		else \
			echo "Installing oh-my-zsh"; \
			curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash; \
			echo "Installation finished"; \
		fi \
	else \
		echo "Zsh was not found. Ohmyzsh will not be installed."; \
	fi

.PHONY: ohmyzsh-plugins
ohmyzsh-plugins: ## Install oh-my-zsh plugins
	@echo "=== Installing Oh-my-zsh Plugins ==="
	@echo "Checking for oh-my-zsh..."
	@if [ -d $(HOME)/.oh-my-zsh ]; then \
		echo "Found oh-my-zsh!"; \
		\
		echo "Checking for zsh-autosuggestions..."; \
		if [ ! -d $(HOME)/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then \
			echo "Installing zsh-autosuggestions..."; \
			git clone https://github.com/zsh-users/zsh-autosuggestions $(HOME)/.oh-my-zsh/custom/plugins/zsh-autosuggestions; \
			echo "Installation finished!"; \
		else \
			echo "zsh-autosuggestions is already installed."; \
		fi; \
		\
		echo "Checking for zsh-syntax-highlighting..."; \
		if [ ! -d $(HOME)/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then \
			echo "Installing zsh-syntax-highlighting..."; \
			git clone https://github.com/zsh-users/zsh-syntax-highlighting $(HOME)/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting; \
			echo "Installation finished"; \
		else \
			echo "zsh-syntax-highlighting is already installed."; \
	fi; \
	else \
		echo "oh-my-zsh was not found. The plugins will not be installed."; \
	fi

.PHONY: ohmyzsh-verify
ohmyzsh-verify: ## Verify installation of oh-my-zsh and plugins
	@echo "=== Verifying installation of oh-my-zsh and plugins ==="
	@echo -n "Checking for Oh-my-zsh...		"
	@if [  -d $(HOME)/.oh-my-zsh ]; then \
		echo "✓ Installed"; \
	else \
		echo "✗ Not installed"; \
		exit 1; \
	fi
	@echo -n "Checking for zsh-autosuggestions...	"
	@if [ -d $(HOME)/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then \
		echo "✓ Installed"; \
	else \
		echo "✗ Not installed"; \
	fi
	@echo -n "Checking for zsh-syntax-highlighting...	"
	@if [  -d $(HOME)/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then \
		echo "✓ Installed"; \
	else \
		echo "✗ Not installed"; \
	fi

.PHONY: dotfiles
dotfiles: ## Link the zsh dotfiles.
	@echo "=== Linking Zsh Dotfiles ==="
	@echo "Checking for .zshrc..."
	@if [ -f $(HOME)/.zshrc ]; then \
		echo "Found .zshrc!"; \
		echo "Generating sources for .zshrc..."; \
		if ! grep -q "Generated by dotfiles" $(HOME)/.zshrc 2>/dev/null; then \
			echo "\n# Generated by dotfiles" >> $(HOME)/.zshrc; \
			echo "Added header!"; \
		fi; \
		if ! grep -q "$(CURDIR)/zsh/aliases.zsh" $(HOME)/.zshrc 2>/dev/null; then \
			echo "source $(CURDIR)/zsh/aliases.zsh" >> $(HOME)/.zshrc; \
			echo "Added aliases.zsh!"; \
		fi; \
		if ! grep -q "functions.zsh" $(HOME)/.zshrc 2>/dev/null; then \
			echo "source $(CURDIR)/zsh/functions.zsh" >> $(HOME)/.zshrc; \
			echo "Added functions.zsh!"; \
		fi; \
		if ! grep -q "ls_colors.zsh" $(HOME)/.zshrc 2>/dev/null; then \
			echo "source $(CURDIR)/zsh/ls_colors.zsh" >> $(HOME)/.zshrc; \
			echo "Added ls_colors.zsh!"; \
		fi; \
		if ! grep -q "history.zsh" $(HOME)/.zshrc 2>/dev/null; then \
			echo "source $(CURDIR)/zsh/history.zsh" >> $(HOME)/.zshrc; \
			echo "Added history.zsh!"; \
		fi; \
		if ! grep -q "zsh-autosuggestions.zsh" $(HOME)/.zshrc 2>/dev/null; then \
			echo "source $(HOME)/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> $(HOME)/.zshrc; \
			echo "Added zsh-autosuggestions.zsh!"; \
		fi; \
		if ! grep -q "zsh-syntax-highlighting.zsh" $(HOME)/.zshrc 2>/dev/null; then \
			echo "source $(HOME)/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> $(HOME)/.zshrc; \
			echo "Added zsh-syntax-highlighting.zsh!"; \
		fi; \
		echo "Finished generating sources!"; \
	fi;

.PHONY: tmux-config
tmux-config: ## Symlink file to config placement
	@echo "=== Linking Tmux Config ==="
	@echo "Checking for .tmux.conf"
	@if [ ! -f $(HOME)/.tmux.conf ]; then \
		echo ".tmux.conf not present."; \
		echo "Creating symlinks..."; \
		ln -s $(CURDIR)/tmux/tmux.conf $(HOME)/.tmux.conf; \
		ln -s $(CURDIR)/tmux/tmux-files/ $(HOME)/.config/; \
		echo "Symlinks created!"; \
		echo "Cloning Tmux package manager"; \
		git clone https://github.com/tmux-plugins/tpm $(HOME)/.tmux/plugins/tpm; \
		echo "Cloning finished!"; \
	else \
		echo "Tmux config already exists."; \
	fi;

.PHONY: alacritty-config
alacritty: ## Link Alacritty config
	@echo "=== Linking Alacritty Config ==="
	@echo "Checking for .alacritty.toml..."
	@if [ -L "$(HOME)/.alacritty.toml" ]; then \
		echo ".alacritty.toml has already been linked!"; \
	else \
		echo ".alacritty.toml was not found."; \
		ln -s $(CURDIR)/alacritty/config.toml $(HOME)/.alacritty.toml; \
		echo "Alacritty config has been linked!"; \
	fi;

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
