quick and easy cloud storage with dufs and nixos

[dufs](https://github.com/sigoden/dufs) - the distinctive file utility server - is a decent cloud storage replacement for those looking to move away from third-party services like google drive or proton drive. it supports webdav and https file transfer protocols.

it's very easy to set up and get going in nixos using a docker container.

## set up dufs 

first, enable docker in your `configuration.nix`: 

```nix
virtualisation.docker.enable = true;
```

then define a docker container, either in your `configuration.nix` or in a custom module:

```nix
virtualisation.oci-containers = {
    backend = "docker";

    containers.dufs = {
        autoStart = true; # automatically restart server after reboot

        image = "sigoden/dufs";

        ports = [
            "5000:5000"
        ];

        volumes = [
            "/srv/dufs:/data" # the files i want to serve are in /srv/dufs
        ];

        # tells dufs to serve the files in the docker volume /data
        cmd = [
            "-A"
            "/data"
        ];
    };
};
```

rebuild your configuration using `nixos-rebuild switch` and head on over to http://localhost:5000 to behold your lovely files.  

# set up tailscale

you can use [tailscale](https://tailscale.com/) to access the files on other devices inside (and outside) of your home network. tailscale is like a crazy-fast vpn with a bunch of other comfort features like [magic dns](https://tailscale.com/kb/1081/magicdns), [keyless ssh](https://tailscale.com/kb/1193/tailscale-ssh) and [easy https](https://tailscale.com/kb/1153/enabling-https).

to enable it in nixos, add the following to your `configuration.nix`:

```nix
services.tailscale.enable = true;
networking.firewall.trustedInterfaces = [ "tailscale0" ]; # lets tailscale use whichever ports it likes
```

once again, rebuild your configuration using `nixos-rebuild switch` and run `tailscale up` to start tailscale.

i reccomend enabling magic dns in admin console > dns > magic dns, but if you prefer not to, your server's ip address will be visible by running `tailscale ip -4`.

now for the fun part, putting everything together!

head over to `http://<hostname or ip>:5000` on one of your other machines to upload, download, and view your self-hosted files.

## clients

as for client recommendations, [round sync](https://github.com/newhinton/Round-Sync) on android is good, and [file browser go](https://www.stratospherix.com/filebrowsergo/) on ios isn't terrible. i'm yet to find something better.

thanks for stopping by ^.^

;tags: self hosting, cloud storage, nixos, tailscale

