{ ... }:

{
    sops = {
        age.keyFile = "/home/daniel/.config/sops/age/keys.txt";
        defaultSopsFile = ./home.yaml;
        defaultSymlinkPath = "/run/user/1000/secrets";
        defaultSecretsMountPoint = "/run/user/1000/secrets.d"; 

        secrets = {};
    };
}
