{ pkgs, ... } : {
# Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sethb = {
    isNormalUser = true;
    description = "Seth Barberee";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      vlc
    ];
  };
}
