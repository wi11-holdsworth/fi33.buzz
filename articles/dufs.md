quick and easy cloud storage with dufs and nixos

dufs[1] -- the distinctive file utility server -- is a decent cloud storage replacement for those looking to move away from third-party services like google drive or proton drive. it supports webdav and https file transfer protocols.

it's very easy to set up and get going in nixos using a docker container.

## set up dufs 

first, enable docker in your `configuration.nix`: 
```
virtualisation.docker.enable = true;
```

then define a docker container, either in your `configuration.nix` or in a custom module:
```
virtualisation.oci-containers = {
    backend = "docker";

    containers.dufs = {
        # automatically restart server after reboot
        autoStart = true; 

        image = "sigoden/dufs";

        ports = [
            "5000:5000"
        ];

        # the files i want to serve are in /srv/dufs
        volumes = [
            "/srv/dufs:/data" 
        ];

        # tells dufs to serve the files in the docker volume /data
        cmd = [
            "-A"
            "/data"
        ];
    };
};
```

rebuild your configuration using `nixos-rebuild switch` and head on over to `http://localhost:5000` to behold your lovely files.  

## set up tailscale

you can use tailscale[2] to access the files on other devices inside (and outside) of your home network. tailscale is like a crazy-fast vpn with a bunch of other comfort features like magic dns[3], keyless ssh[4] and easy https[5].

to enable it in nixos, add the following to your `configuration.nix`:
```
services.tailscale.enable = true;
networking.firewall.trustedInterfaces = [ "tailscale0" ];
```

once again, rebuild your configuration using `nixos-rebuild switch` and run `tailscale up` to start tailscale.

i recommend enabling magic dns in admin console > dns > magic dns, but if you prefer not to, your server's ip address will be visible by running `tailscale ip -4`.

head over to `http://<hostname or ip>:5000` on one of your other machines running tailscale to upload, download, and view your self-hosted files.

## dufs clients

as for client recommendations, round sync[6] on android is quite good. it supports both webdav and https remotes, i chose to use webdav when connecting. 

thanks for stopping by ^.^

[1] [dufs](https://github.com/sigoden/dufs)

[2] [tailscale](https://tailscale.com/)

[3] [magic dns](https://tailscale.com/kb/1081/magicdns)

[4] [tailscale ssh](https://tailscale.com/kb/1193/tailscale-ssh)

[5] [tailscale https](https://tailscale.com/kb/1153/enabling-https)

[6] [round sync](https://github.com/newhinton/Round-Sync)

;tags: self-hosting cloud-storage nixos tailscale

