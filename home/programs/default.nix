{ config, pkgs, ... }:

{
  imports = [ 
	./git.nix 
	# ./media.nix 
	./browsers.nix 
	./common.nix ];
}
