# easy_tf_do
A simple [Terraform] (http://terraform.io) configuration for spinning up a [DigitalOcean] (https://digitalocean.com) Droplet, and installing NGINX. This is really just a demo to show how easy it is to get started with Terraform.

# Setup
You'll need to set up a DigitalOcean account, if you don't have one, you can use my [Referral Link] (https://www.digitalocean.com/?refcode=38b47f5765f4) to get a free credit! (I get some too).

Once you have a DO account, you'll need to set up a "Personal Access Token" (PAT) for the API. and an SSH key setup as well. See these excellent DigitalOcean tutorials for how to do that:

- [How To Use the DigitalOcean API v2] (https://www.digitalocean.com/community/tutorials/how-to-use-the-digitalocean-api-v2#HowToGenerateaPersonalAccessToken)
- [How To Use SSH Keys with DigitalOcean Droplets] (https://www.digitalocean.com/community/tutorials/how-to-use-ssh-keys-with-digitalocean-droplets)

And of course, you'll want to install Terraform. You can use the downloads page, [here] (http://www.terraform.io/downloads.html) to download the appropriate package for your platform. I'm assuming you're running from _not Windows_ (sorry).

My Terraform configuration assumes that the configuration variables are available via environment variables:

```bash
export TF_VAR_do_token={your_PAT}
export TF_VAR_ssh_fingerprint=$(ssh-keygen -lf ~/.ssh/id_rsa.pub | awk '{print $2}')
export TF_VAR_pub_key=$HOME/.ssh/do_rsa.pub
export TF_VAR_pvt_key=$HOME/.ssh/do_rsa
```

Alternatively, you can pass in the variables to the terraform command line interface:

```bash
export DO_PAT={your_PAT}
export SSH_FINGERPRINT=$(ssh-keygen -lf ~/.ssh/id_rsa.pub | awk '{print $2}')
terraform plan \
  -var "do_token=${DO_PAT}" \
  -var "pub_key=$HOME/.ssh/do_rsa.pub" \
  -var "pvt_key=$HOME/.ssh/do_rsa" \
  -var "ssh_fingerprint=$SSH_FINGERPRINT"
```

# Usage
Now that you've' got your DO access setup and your environment configured, you're ready to go! Clone this repo if you haven't done so already:

```bash
git clone https://github.com/thejaywhy/easy_tf_do.git
```

Now to the fun part, planning out your deployment:

```bash
terraform plan

+ digitalocean_droplet.web
    image:                "" => "ubuntu-14-04-x64"
    ipv4_address:         "" => "<computed>"
    ipv4_address_private: "" => "<computed>"
    ipv6_address:         "" => "<computed>"
    ipv6_address_private: "" => "<computed>"
    locked:               "" => "<computed>"
    name:                 "" => "web-1"
    region:               "" => "nyc3"
    size:                 "" => "512mb"
    ssh_keys.#:           "" => "1"
    ssh_keys.0:           "" => "${ssh_fingerprint}"
    status:               "" => "<computed>"
```

Which shows you exactly what this Terraform configuration is going to do. To apply it, all you have to do is run:

```
terraform apply
# ...bunch of output....
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

The state of your infrastructure has been saved to the path
below. This state is required to modify and destroy your
infrastructure, so keep it safe. To inspect the complete state
use the `terraform show` command.

State path: terraform.tfstate

Outputs:

  ipv4 = <droplet public ip>
```

You should now be able to visit the IP address and see the standard NGINX welcome screen. Hooooray!

## Cleaning up
I'll assume you don't want this super simple droplet to be eating into your wallet, you'll probably want to shut it down! You could use the Web UI or another API wrapper, or use Terraform, it'll be easy.

```bash
terraform plan -destroy
- digitalocean_droplet.web
terraform destroy
Do you really want to destroy?
  Terraform will delete all your managed infrastructure.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

digitalocean_droplet.web: Refreshing state... (ID: 5364117)
digitalocean_droplet.web: Destroying...
digitalocean_droplet.web: Destruction complete

Apply complete! Resources: 0 added, 0 changed, 1 destroyed.
```

# Considerations
Thanks to HashiCorp and DigitalOcean for making super easy to use tools!

# Author
[thejaywhy] (https://github.com/thejaywhy)
