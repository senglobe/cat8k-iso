import os
import time
import glob


def listdir_nohidden(path):
    return glob.glob(os.path.join(path, '*'))


configs = listdir_nohidden("Routers/Configs")


for config in configs:
    outfile = config.split(".")
    print(outfile[0])
    os.system(f"mkisofs -l -o {outfile[0]}.iso {config}")

filenames = listdir_nohidden("Routers")

for file in filenames:
    os.system(f"terraform apply -var-file={file} -auto-approve")
    time.sleep(600)
    os.system(f"cp terraform.tfstate terraform.tfstate.{file}")





