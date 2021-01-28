# Create SSH keys
ssh-keygen -t rsa

# Show Public key
cat /home/robin/.ssh/id_rsa.pub

# Cloning repository
git clone git@github.com:rtebrake/udacity-devops-cicd.git

# Add file to repository
git add make_predict_azure_app.sh
git commit -m "Comment"
git push

#Check status
git status

# Python Virtual Environment
python3 -m venv ~/.myrepo
source ~/.myrepo/bin/activate

# Pip
pip install -r requirements.txt

# Make .sh file executable
chmod +x ./make_predict_azure_app.sh

# Create Azure webapp based on the B1 SKU
az webapp up -n rtb-udacity-devops-cicd --sku b1

# Show streaming logs
 az webapp log show --resource-group robin_rg_linux_centralus --name rtb-udacity-devops-cicd

# Locust
locust -f ./locustfile.py
