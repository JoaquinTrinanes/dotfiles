# shellcheck source-path=~/.nix-profile/etc/profile.d/

if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
	. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
fi
