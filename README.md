# **ATLANTIS TERRAFORM AUTOMATION**

**_published at_ 10/01/2024**

## **Table of Contents:**

1. Create VM server and allow http firewall
2. Install Terraform, terragrunt, and atlantis
3. Create credentials for you terraform access to your GCP
4. Generate Github Token
5. Start Atlantis
6. Create Github Weebhook
7. Create systemd atlantis.service
8. Reverse Proxy With NGINX & Certbot, and check auto renewal
9. Make command shortcut

## **Pre-Requirements**

- learn more about terraform & terragrunt [here](https://github.com/ahmadpiee/terraform-sessions)

  ## **Content:**

1. **Create VM server and allow http, and https firewall:**, and ssh to your server.

2. **Install Terraform, Terragrunt, and Atlantis:** [here](https://developer.hashicorp.com/terraform/install?product_intent=terraform#Linux) the link how you can install terraform, [here](https://terragrunt.gruntwork.io/docs/getting-started/install/) the link you can install terragrunt, [here](https://www.runatlantis.io/guide/testing-locally.html#download-atlantis) the link how you can install Atlantis, or you can follow the steps below:

- install terraform : `wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list && sudo apt update && sudo apt install terraform`
- install terragrunt : `wget https://github.com/gruntwork-io/terragrunt/releases/download/<change_with_the_latest_version>/terragrunt_linux_amd64` (make sure your CPU is match with the repository, in this case we download terragrunt_linux_amd64), and then you need to rename the downloaded file to `terragrunt`, and you need to give permission to the binary by running `chmod u+x terragrunt`, and last you need to move the binary to the `/usr/local/bin` folder by running `sudo mv terragrunt /usr/local/bin/terragrunt`
- install atlantis : `wget https://github.com/runatlantis/atlantis/releases/download/<change_with_the_latest_version>/atlantis_linux_amd64.zip`, and make sure the repository is match with your CPU type. after you download the file, you need to unzip it by running `unzip atlantis_linux_amd64.zip`, and then you need to move the file to the `/usr/local/bin` folder by running `sudo mv atlantis /usr/local/bin/atlantis`, don't forget to remove unused downloaded file, make sure your atlantis already installed by running `atlantis version`

3. **Create credentials for you terraform access to your GCP:**

   - Make production & staging credentials file by running `sudo vim /etc/atlantis/production-credentials.json` and copy paste you credentials key that you generated from you IAM console, also don't forget to create your staging credentials: `sudo vim /etc/atlantis/staging-credentials.json`

4. **Generate Github Token**: go to your github then click settings > developer settings > personal access tokens > Token (classic) > Generate new token (classic) > (check repo only) copy paste on your clipboard the token and save it.

5. **Start Atlantis:** make folder `sudo mkdir /etc/atlantis` & `cd /etc/atlantis/` & `sudo vim atlantis.yaml` and copy paste this atlantis configuration to your atlantis.yaml file:
   ```
   repos:
   - id: /.*/
     apply_requirements: [approved,mergeable]
     workflow: terragrunt
     allowed_overrides: []
     allow_custom_workflows: true
   workflows:
     terragrunt:
       plan:
         steps:
         - env:
             name: TERRAGRUNT_TFPATH
             command: 'echo "terraform"'
         - env:
             name: DESTROY_PARAMETER
             command:  if [ "$COMMENT_ARGS" = "\-\d\e\s\t\r\o\y" ]; then echo "-destroy"; else echo ""; fi
         - run: terragrunt validate-inputs --terragrunt-non-interactive -no-color
         - run: terragrunt plan --terragrunt-non-interactive -no-color -out=$PLANFILE $DESTROY_PARAMETER
       apply:
         steps:
         - env:
             name: TERRAGRUNT_TFPATH
             command: 'echo "terraform"'
         - run: terragrunt apply --terragrunt-non-interactive -no-color $PLANFILE
   ```
   and running, and testing it by github command:
   `sudo atlantis server --atlantis-url="http://Your_IP4_Public" --gh-user="Your_Github_Username" --gh-token="Your_Github_Token" --gh-webhook-secret="Your_Webhook_Secret" --repo-allowlist="Your_Repository_URL --port=80"`
6. **Create Github Weebhook:**

   - Go to your repo's settings
   - Select Webhooks or Hooks in the sidebar
   - Click Add webhook
   - set Payload URL to your ip4_public url with /events at the end. Ex. https://your_ip4_public/events
   - double-check you added /events to the end of your URL.
   - set Content type to application/json
   - set Secret to your random string
   - select Let me select individual events
   - check the boxes:
     - Pull request reviews
     - Pushes
     - Issue comments
     - Pull requests
   - leave Active checked
   - click Add webhook

7. **Create systemd atlantis.service:** the purpose is to running atlantis server at startup, and running atlantis on detach/background mode

   - `sudo vim /etc/systemd/system/atlantis.service`
   - in the editor copy paste the following script (note that the port now is running on 8080 so you have to allow in your firewall, and also you need to adjust the payload url on your github webhook):

     ```
     [Unit]
     Description=Atlantis Service

     [Service]
     ExecStart=/usr/local/bin/atlantis server --atlantis-url="http://Your_IP4_Public" --gh-user="Your_Github_Username" --gh-token="Your_Github_Token" --gh-webhook-secret="Your_Webhook_Secret" --repo-allowlist="Your_Repository_URL" --port=8080 --repo-config="/etc/atlantis/atlantis.yaml
     Restart=always

     [Install]
     WantedBy=multi-user.target
     ```

   - Enable and start the atlantis service so it starts when the system boots:
     - `sudo systemctl enable atlantis.service`
     - `sudo systemctl start atlantis`
     - `sudo systemctl status atlantis` to see the status

8. **Reverse Proxy With NGINX & Certbot:**

   - install nginx: `sudo apt install nginx -y`
   - enable nginx: `sudo systemctl enable nginx`
   - create upstream: `sudo vim /etc/nginx/conf.d/upstream.conf` and add the following script:
     ```
     upstream atlantis {
     	server Your_IP4_Public:8080;
     }
     ```
   - modify sites-available config (note that you can create new sites-available config and symlink it, or you can modify the default config, in this case we will modify the default config): `cd /etc/nginx/sites-availabe/default` and change the block code of:
     ```
     location / {
     			proxy_pass http://atlantis;
     			proxy_http_version 1.1;
     			proxy_set_header X-Forwarded-Host $host;
     			proxy_set_header X-Forwarded-Server $host;
     			proxy_set_header X-Real-IP $remote_addr;
     			proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
     			proxy_set_header X-Forwarded-Proto $scheme;
     			proxy_set_header Host $http_host;
     			proxy_set_header Upgrade $http_upgrade;
     			proxy_set_header Connection "Upgrade";
     			proxy_pass_request_headers on;
     }
     ```
   - don't forget to test it out by running `sudo nginx -t` if the status seems like this:
     ```
     nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
     nginx: configuration file /etc/nginx/nginx.conf test is successful
     ```
   - it means your config is correct
   - then reload your nginx `sudo systemctl reload nginx`
   - next we can make ssl certificate wit **Certbot**, to install cerbot running this command `sudo apt install certbot python3-certbot-nginx && sudo nginx -t && sudo systemctl reload nginx`
   - add your domain to nginx/certbot challange by running `sudo certbot --nginx -d example.com -d www.example.com` make sure to change your domain, and point your A record to your ip4 public in your DNS Zone
   - now you can access you atlantis app by go to your domain with https
   - last, you need to check a certbot auto renewal test by running the following command:

     ```
     sudo systemctl status certbot.timer

     sudo certbot renew --dry-run
     ```

9. **Make command shortcut:**

   - created **.bash_aliases** file for config all your aliases: `sudo vim ~/.bash_aliases`
   - and put all the following alias command into your bash aliases file:
     ```
     alias stop="sudo systemctl daemon-reload && sudo systemctl stop atlantis"
     alias enable="sudo systemctl enable atlantis.service"
     alias start="sudo systemctl start atlantis"
     alias restart="sudo systemctl restart atlantis"
     alias status="sudo systemctl status atlantis"
     ```
   - the command above is to make some shortcuts for easier life, and last you need to activate the bash aliases update by running `source ~/.bash_aliases`
   - now you can try by typing the command e.g `stop` for stopping the atlantis service, and `start` to start again the atlantis service
