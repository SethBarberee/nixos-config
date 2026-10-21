# Audio aspect: pipewire + alsa, optional pulseaudio
# Present on both hosts.
{ inputs, ... }:
{
  den.aspects.audio = {
    nixos = { pkgs, ... }: {
      services = {
        pulseaudio.enable = false;
        pipewire = {
          enable = true;
          audio.enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
        };
      };
    };
  };
}
